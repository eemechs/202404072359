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
name          = "globo-adtech-comment-apigw-dev"
description   = "HTTP API Gateway"
protocol_type = "HTTP"

cors_configuration = {
  allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
  allow_methods = ["*"]
  allow_origins = ["*"]
}

# Access logs
default_stage_access_log_destination_arn = ""
default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

# Routes and integrations
routes = {
  "/api/comment/new" = {
    methods = ["POST"]
    integration = {
      integration_type = "HTTP_PROXY"
      uri              = "http://ec2-34-227-94-125.compute-1.amazonaws.com/api/comment/new"
    }
  }

  "/api/comment/list/{content_id}" = {
    methods = ["GET"]
    integration = {
      integration_type = "HTTP_PROXY"
      uri              = "http://ec2-34-227-94-125.compute-1.amazonaws.com/api/comment/list/{content_id}"
    }
  }

  "$default" = {
    methods = ["ANY"]
    integration = {
      integration_type = "HTTP_PROXY"
      uri              = "http://ec2-34-227-94-125.compute-1.amazonaws.com/"
    }
  }
}

tags = {
  Name = "globo-adtech-comment-apigw-dev"
}
EOF
}
