# enable the compute API
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

# enable the container API (to be used for the GKE)
resource "google_project_service" "container" {
  service = "container.googleapis.com"

  disable_dependent_services = true
}

# enabling the VPC
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "main" {
  project                         = var.project_id
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = var.auto_create_subnetworks
  mtu                             = var.mtu
  delete_default_routes_on_create = var.delete_default_routes_on_create

  # explicitly specify that the compute and container services need to be created before VPC
  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

#enabling the subnets
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  project                  = var.project_id
  name                     = "private"
  ip_cidr_range            = var.subnet_cidr_range
  region                   = var.region
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  # these secondary IP ranges are for the Kubernetes Pods
  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = var.pod_ip_range
  }
  # these secondary IP ranges are for the Kubernetes Services
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = var.service_ip_range
  }
}


# enabling cloud router
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network = google_compute_network.main.id
}

# enabling cloud NAT
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  region = var.region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

# enabling addresses
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}

# enable firewall
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.allow_ssh_from
}