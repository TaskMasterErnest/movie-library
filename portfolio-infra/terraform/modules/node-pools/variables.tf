variable "machine_type" {
  description = "Machine type to use for node VM"
  type        = string
}

variable "disk_type" {
  description = "Type of disk to use"
  type        = string
}

variable "disk_size_gb" {
  description = "Value in GB of disk size to use"
  type        = number
}

variable "container_cluster" {
  description = "Name of container cluster"
}

variable "project_id" {
  description = "Name of project bein worked on"
  type        = string
}

variable "service_account_id" {
  description = "Name of service account to hook to"
  type        = string
}