variable "primary_location" {
  description = "The primary location for where the master node will be"
  type        = string
}

variable "node_locations" {
  description = "Secondary location for multi-zonal deployment"
  type        = list(string)
}

variable "region" {
  description = "The region to use"
  type        = string
}

variable "workload_identity_config" {
  description = "Workload Identity for Kubernetes cluster"
  type        = string
}

variable "google_compute_network" {
  description = "Name of VPC created"
  type        = string
}

variable "google_compute_subnetwork" {
  description = "Name of subnet created"
  type        = string
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type = string
}