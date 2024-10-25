output "container_cluster" {
  description = "Name of container cluster used"
  value = google_container_cluster.primary.id
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = base64encode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

output "cluster_token" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "cluster" {
  value = google_container_cluster.primary
}