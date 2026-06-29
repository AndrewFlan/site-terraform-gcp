# ---------------------------------------------------------
# DNS
# Your domain stays registered in AWS Route53 (Option B from
# our discussion) — this file is intentionally left as a
# placeholder/reference.
#
# Rather than managing AWS Route53 records from within this
# GCP Terraform repo (which would require the AWS provider
# here too), the simpler approach is to update the existing
# Route53 records in your site-terraform (AWS) repo to point
# at the GCP static IP output from this repo.
#
# After running `terraform apply` here, take the `static_ip`
# output and update the `records` field in your AWS repo's
# dns.tf, e.g.:
#
#   resource "aws_route53_record" "root" {
#     ...
#     records = ["<GCP_STATIC_IP>"]
#   }
#
# This keeps DNS management in one place (Route53) while the
# actual server moves to GCP.
# ---------------------------------------------------------
