# terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
    source = "git::github.com/terraform-aws-modules/terraform-aws-ec2-instance.git//?ref=v5.6.1"
}

inputs = {
  user_data = file("${get_terragrunt_dir()}/template/api_server.tpl")
}

generate "tfvars" {
  path      = "terragrunt.auto.tfvars"
  if_exists = "overwrite"
  disable_signature = true
  contents = <<-EOF
ami                           = "ami-051f8a213df8bc089"
create_spot_instance          = true
create_iam_instance_profile   = true
instance_type                 = "t2.micro"
monitoring                    = true
name                          = "ec2-comment-api"
EOF
}
# Use this block just to Localstack tests
// generate "provider" {
//   path = "provider.tf"
//   if_exists = "overwrite_terragrunt"
//   contents = <<EOF
// provider "aws" {
//   access_key                  = "test"
//   secret_key                  = "test"
//   region                      = "us-east-1"
//   s3_use_path_style           = false
//   skip_credentials_validation = true
//   skip_metadata_api_check     = true

//   endpoints {
//     apigateway     = "http://localhost:4566"
//     apigatewayv2   = "http://localhost:4566"
//     cloudformation = "http://localhost:4566"
//     cloudwatch     = "http://localhost:4566"
//     dynamodb       = "http://localhost:4566"
//     ec2            = "http://localhost:4566"
//     es             = "http://localhost:4566"
//     elasticache    = "http://localhost:4566"
//     firehose       = "http://localhost:4566"
//     iam            = "http://localhost:4566"
//     kinesis        = "http://localhost:4566"
//     lambda         = "http://localhost:4566"
//     rds            = "http://localhost:4566"
//     redshift       = "http://localhost:4566"
//     route53        = "http://localhost:4566"
//     s3             = "http://s3.localhost.localstack.cloud:4566"
//     secretsmanager = "http://localhost:4566"
//     ses            = "http://localhost:4566"
//     sns            = "http://localhost:4566"
//     sqs            = "http://localhost:4566"
//     ssm            = "http://localhost:4566"
//     stepfunctions  = "http://localhost:4566"
//     sts            = "http://localhost:4566"
//   }
// }
// EOF
// }
