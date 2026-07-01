# About

This repository stores the Terraform code to manage the GCP Infrastructure for my Personal Website [andrewflanigan.com](andrewflanigan.com)

## What it does

Terraform performs these tasks:

- Sets up a Compute Engine Instance:
  - Runs the latest Ubuntu 24.04 LTS image (`e2-micro`)
  - Assigns a static external IP address
  - SSH access managed via OS Login (`enable-oslogin`)
  - Attached service account scoped to least-privilege access
- Sets up Firewall Rules:
  - Allows SSH Ingress via IAP only (Google's Identity-Aware Proxy range `35.235.240.0/20`)
  - Allows HTTP/HTTPS Ingress from any IP
  - Disables the default GCP `allow-ssh` and `allow-rdp` rules
- Sets up a GCS Bucket for site file deployment staging:
  - The instance's service account has `roles/storage.objectAdmin` on this bucket
  - Files older than 1 day are automatically deleted
- Stores Terraform State in a GCS Bucket (`andrewflanigan-terraform-state-gcp`)

## GitHub Workflows/Actions

This repository also has a couple GitHub Workflow/Actions set up:

- Runs [tflint](https://github.com/terraform-linters/tflint) on pull requests/merges
- Runs [Dependabot](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/dependabot-quickstart-guide) weekly
- Runs Terraform Init and Plan on pull requests and Apply when merged to main:
  - Posts the Terraform plan output as a PR comment (updates the comment on re-runs)
  - After apply, exports the instance name as a secret to the [my-website](https://github.com/AndrewFlan/my-website) repo so deploy workflows can reference it
  - Authentication uses GCP Workload Identity Federation — no long-lived service account keys are stored; sessions are short-lived
