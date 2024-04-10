# terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
    source =  "git::github.com/terraform-aws-modules/terraform-aws-ec2-instance.git//?ref=v5.6.1"
}

generate "tfvars" {
  path      = "terragrunt.auto.tfvars"
  if_exists = "overwrite"
  disable_signature = true
  contents = <<-EOF
ami                           = "ami-051f8a213df8bc089"
create_iam_instance_profile   = true
create_spot_instance          = true
instance_type                 = "t2.micro"
monitoring                    = true
name                          = "ec2-comment-api"

iam_role_policies = {
  "AmazonSSMManagedInstanceCore" : "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
user_data = "${filebase64("${get_terragrunt_dir()}/template/api_server.tpl")}"
EOF
}