# terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
    source =  "git::github.com/terraform-aws-modules/terraform-aws-ecr.git"
}

generate "tfvars" {
  path      = "terragrunt.auto.tfvars"
  if_exists = "overwrite"
  disable_signature = true
  contents = <<-EOF
repository_name = "comment-api"
create_lifecycle_policy = false
EOF
}