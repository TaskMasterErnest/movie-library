output "vpc_name" {
  description = "Name of the VPC created"
  value       = google_compute_network.main.self_link
}

output "subnet_name" {
  description = "Name of subnet created"
  value       = google_compute_subnetwork.private.self_link
}