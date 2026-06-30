terraform {
  required_version = ">= 1.15.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }

  # Remote state in Google Cloud Storage
  backend "gcs" {
    bucket = "andrewflanigan-terraform-state-gcp"
    prefix = "personal-site"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# ---------------------------------------------------------
# Static External IP
# ---------------------------------------------------------
resource "google_compute_address" "web" {
  name   = "${var.project_name}-ip"
  region = var.region
}

# ---------------------------------------------------------
# Service Account for the Compute Engine instance
# ---------------------------------------------------------
resource "google_service_account" "web" {
  account_id   = "${var.project_name}-sa"
  display_name = "Web server service account"
}

# ---------------------------------------------------------
# GCS Bucket for site file deployment staging
# ---------------------------------------------------------
resource "google_storage_bucket" "site_deploy" {
  name                        = var.deploy_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true # allows bucket deletion even if files remain

  # Avoid stale files piling up if a deploy ever fails midway
  lifecycle_rule {
    condition {
      age = 1 # days
    }
    action {
      type = "Delete"
    }
  }
}

# Grants the service account permission to read/write the
# site-deploy bucket
resource "google_storage_bucket_iam_member" "web_sa_storage" {
  bucket = google_storage_bucket.site_deploy.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.web.email}"
}

# ---------------------------------------------------------
# Compute Engine Instance
# ---------------------------------------------------------
resource "google_compute_instance" "web" {
  name         = "${var.project_name}-web"
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.web.address
    }
  }

  metadata = {
    ssh-keys               = join("\n", [for key in var.ssh_public_keys : "ubuntu:${key}"])
    block-project-ssh-keys = "true"
  }

  service_account {
    email  = google_service_account.web.email
    scopes = ["cloud-platform"]
  }

  tags = ["web-server"]
}
