locals {
  tfc_hostname     = "app.terraform.io" 
  tfc_organization = "globo-adtech"
  workspace        = "dev"
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "remote" {
    hostname = "${local.tfc_hostname}"
    organization = "${local.tfc_organization}"
    workspaces {
      name = "${local.workspace}"
    }
  }
}
EOF
}