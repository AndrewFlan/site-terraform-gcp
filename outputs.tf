output "static_ip" {
  description = "Static external IP of the Compute Engine instance"
  value       = google_compute_address.web.address
}

output "instance_name" {
  description = "Name of the Compute Engine instance"
  value       = google_compute_instance.web.name
}

output "instance_id" {
  description = "ID of the Compute Engine instance"
  value       = google_compute_instance.web.instance_id
}

output "service_account_email" {
  description = "Email of the service account attached to the instance"
  value       = google_service_account.web.email
}

output "deploy_bucket_name" {
  description = "Name of the GCS bucket used for site deploy staging"
  value       = google_storage_bucket.site_deploy.name
}

output "ssh_command" {
  description = "Command to SSH into the server"
  value       = "ssh -i ~/.ssh/personal-site ubuntu@${google_compute_address.web.address}"
}
