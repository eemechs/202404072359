# terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
    source = "git::https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2"
}

generate "tfvars" {
  path      = "terragrunt.auto.tfvars"
  if_exists = "overwrite"
  disable_signature = true
  contents = <<-EOF
EOF
}
