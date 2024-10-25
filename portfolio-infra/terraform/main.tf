# enabling the modules

# the network module
module "network" {
  source = "./modules/network"

  region     = var.region
  project_id = var.project_id

  service_ip_range                = var.service_ip_range
  delete_default_routes_on_create = var.delete_default_routes_on_create
  subnet_cidr_range               = var.subnet_cidr_range
  pod_ip_range                    = var.pod_ip_range
  mtu                             = var.mtu
  auto_create_subnetworks         = var.auto_create_subnetworks
  allow_ssh_from                  = var.allow_ssh_from
}

# gke module
module "gke-cluster" {
  source = "./modules/gke-cluster"

  region                   = var.region
  workload_identity_config = var.workload_identity_config

  primary_location = var.primary_location
  node_locations   = var.node_locations
  project_id = var.project_id
  cluster_name = var.cluster_name

  google_compute_network    = module.network.vpc_name
  google_compute_subnetwork = module.network.subnet_name
}

module "node-pools" {
  source = "./modules/node-pools"

  disk_size_gb       = var.disk_size_gb
  machine_type       = var.machine_type
  disk_type          = var.disk_type
  project_id         = var.project_id
  service_account_id = var.service_account_id

  container_cluster = module.gke-cluster.container_cluster
}

module "helm-releases" {
  source = "./modules/helm-releases"
}