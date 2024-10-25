data "google_container_engine_versions" "gke_version" {
  location       = var.region
  version_prefix = "1.27."
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "primary" {
  project                  = var.project_id
  name                     = var.cluster_name
  location                 = var.primary_location
  remove_default_node_pool = true # reomoving this ensures that my pd-stnadard disk size is used
  initial_node_count       = 1
  network                  = var.google_compute_network
  subnetwork               = var.google_compute_subnetwork
  logging_service          = "logging.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  # node_locations = var.node_locations

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = true
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = var.workload_identity_config
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "null_resource" "connect_cluster" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.primary_location} --project ${var.project_id}"
  }
  provisioner "local-exec" {
    command = "kubectl config use-context gke_${var.project_id}_${var.primary_location}_${var.cluster_name}"
  }

  depends_on = [ google_container_cluster.primary ]
}