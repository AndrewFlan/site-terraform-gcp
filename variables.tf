variable "project_id" {
  description = "Your GCP project ID (not the display name)"
  type        = string
  default     = "andrewflanigan-site"
}

variable "region" {
  description = "GCP region to deploy into"
  type        = string
  default     = "us-central1"
}

variable "project_name" {
  description = "Used as a prefix on all resource names"
  type        = string
  default     = "my-website"
}

variable "machine_type" {
  description = "Compute Engine machine type"
  type        = string
  default     = "e2-micro"
}

variable "deploy_bucket_name" {
  description = "Name for the GCS bucket created for site file deployment staging — must be globally unique"
  type        = string
  default     = "andrewflanigan-site-deploy"
}

variable "oslogin_user" {
  description = "Google account username for OS Login (format: first_last_domain_com)"
  type        = string
}

variable "ansible_ssh_public_key" {
  description = "SSH public key content to register with OS Login for Ansible access"
  type        = string
}
