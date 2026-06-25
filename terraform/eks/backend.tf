# ============================================================
# terraform/eks/backend.tf
# ============================================================

terraform {
  backend "s3" {
    bucket       = "gk-enterprise-platform-terraform-state-884390772196"
    key          = "eks/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

