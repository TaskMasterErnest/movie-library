variable "auto_create_subnetworks" {
  description = "Allow GCP to create subnetworks for VPC"
  type        = bool
}

variable "delete_default_routes_on_create" {
  description = "Allow GCP to delete default router routes on creation"
  type        = bool
}

variable "mtu" {
  description = "MTU value to use"
  type        = number
}

variable "subnet_cidr_range" {
  description = "Subnet CIDR range to use"
  type        = string
}

variable "region" {
  description = "Region to place subnets in"
  type        = string
}

variable "pod_ip_range" {
  description = "Secondary IP range for Kubernetes pods"
  type        = string
}

variable "service_ip_range" {
  description = "Secondary IP range for Kubernetes services"
  type        = string
}

variable "project_id" {
  description = "ID of the project in GCP"
  type        = string
}

variable "allow_ssh_from" {
  description = "Allow SSH from these IP address"
  type        = list(string)
}