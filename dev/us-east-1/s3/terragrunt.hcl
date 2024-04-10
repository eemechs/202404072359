# terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
    source = ""
}

generate "tfvars" {
  path      = "terragrunt.auto.tfvars"
  if_exists = "overwrite"
  disable_signature = true
  contents = <<-EOF
EOF
}
