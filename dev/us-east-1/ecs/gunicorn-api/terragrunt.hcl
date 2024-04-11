# terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
    source =  "git::github.com/terraform-aws-modules/terraform-aws-ecs.git"
}

generate "tfvars" {
  path      = "terragrunt.auto.tfvars"
  if_exists = "overwrite"
  disable_signature = true
  contents = <<-EOF
cluster_name = "comments-api"
create_task_exec_iam_role = true

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/comments-api"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  services = {
    comments-api = {
      cpu    = 2048
      memory = 4096

      container_definitions = {

        comment-api = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "public.ecr.aws/f8n0u2q9/comments-api:latest"
          port_mappings = [
            {
              name          = "comments-api"
              containerPort = 8000
              protocol      = "tcp"
            }
          ]

          enable_cloudwatch_logging = false

          log_configuration = {
            logDriver = "awslogs"
            options = {
              awslogs-group = "/aws/ecs/comments-api"
              awslogs-region = "us-east-1"
              awslogs-stream-prefix = "ecs"
            }
          }
          memory_reservation = 100

          mount_points = [
            {
              container_path = "/var/tmp"
              source_volume  = "ephemeral-volume"
              read_only      = false
            }
          ]
        }
      }
      
      assign_public_ip = true

      subnet_ids = ["subnet-0d1d822b8d8ca2950", "subnet-075f694a8b04ef458", "subnet-0d1d822b8d8ca2950"]
      security_group_rules = {
        # Allow inbound HTTPS traffic for ECR access
        ecr_access = {
          type                     = "ingress"
          from_port                = 443
          to_port                  = 443
          protocol                 = "tcp"
          description              = "Allow HTTPS access for ECR"
          cidr_blocks              = ["0.0.0.0/0"]  # Restrict if possible in production
        }
        alb_ingress_8000 = {
          type                     = "ingress"
          from_port                = 8000
          to_port                  = 8000
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = "sg-0cf4cc83a2755a18d"
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "globo-adtech"
  }
EOF
}