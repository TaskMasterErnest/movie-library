variable "project_id" {
  description = "ID of project space to be used in GCP"
  type        = string
  default     = "taskmaster-rgt"
}

variable "region" {
  description = "Region to deploy the infrastructure into"
  type        = string
  default     = "europe-west1"
}

variable "credentials_file" {
  description = "Local path to the json file containing service account key"
  type        = string
}

variable "workload_identity_config" {
  description = "Workload identity for Kubernetes to access GCP services"
  type        = string
  # check tfvars for what to use
}

variable "cluster_name" {
  description = "Name of the cluster"
  default = "primary"
}



variable "auto_create_subnetworks" {
  description = "Allow GCP to create subnetworks for VPC"
  type        = bool
  default     = false
}

variable "delete_default_routes_on_create" {
  description = "Allow GCP to delete default router routes on creation"
  type        = bool
  default     = false
}

variable "mtu" {
  description = "MTU value to use"
  type        = number
  default     = 1460
}

variable "subnet_cidr_range" {
  description = "Subnet CIDR range to use"
  type        = string
  default     = "10.0.0.0/18"
}

# variable "region" {
#   description = "Region to place subnets in"
#   type = string
# }

variable "pod_ip_range" {
  description = "Secondary IP range for Kubernetes pods"
  type        = string
  default     = "10.48.0.0/14"
}

variable "service_ip_range" {
  description = "Secondary IP range for Kubernetes services"
  type        = string
  default     = "10.52.0.0/20"
}

# variable "project_id" {
#   description = "ID of the project in GCP"
#   type = string
# }

variable "allow_ssh_from" {
  description = "Allow SSH from these IP address"
  type        = list(string)
  default     = ["41.155.28.62/32"]
}



variable "primary_location" {
  description = "The primary location for where the master node will be"
  type        = string
  default     = "europe-west1-c"
}

variable "node_locations" {
  description = "Secondary location for multi-zonal deployment"
  type        = list(string)
  default     = ["europe-west1-b"]
}

# variable "region" {
#   description = "The region to use"
#   type = string
# }

# variable "workload_identity_config" {
#   description = "Workload Identity for Kubernetes cluster"
#   type = string
# }



variable "machine_type" {
  description = "Machine typr to use for node VM"
  type        = string
  default     = "e2-standard-2"
}

variable "disk_type" {
  description = "Type of disk to use"
  type        = string
  default     = "pd-balanced"
}

variable "disk_size_gb" {
  description = "Value in GB of disk size to use"
  type        = number
  default     = 40
}

variable "service_account_id" {
  description = "Name of service account to hook to"
  type        = string
}