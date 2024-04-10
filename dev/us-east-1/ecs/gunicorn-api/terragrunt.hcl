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
      cpu    = 1024
      memory = 4096

      container_definitions = {

        comment-api = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "664693334577.dkr.ecr.us-east-1.amazonaws.com/comments-api:latest"
          port_mappings = [
            {
              name          = "comments-api"
              containerPort = 8000
              protocol      = "tcp"
            }
          ]

          enable_cloudwatch_logging = true
          log_configuration = {
            logDriver = "awslogs"
            options = {
              awslogs-group = "/aws/ecs/acess-logs/comments-api/"
              awslogs-region = "us-east-1"
              awslogs-create-group = "true"
              awslogs-stream-prefix = "dev"
            }
          }
          memory_reservation = 100
        }
      }

      // service_connect_configuration = {
      //   service = {
      //     client_alias = {
      //       port     = 8000
      //       dns_name = "comments-api"
      //     }
      //     port_name      = "comments-api"
      //     discovery_name = "comments-api"
      //   }
      // }

      // load_balancer = {
      //   service = {
      //     target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:1234567890:targetgroup/bluegreentarget1/209a844cd01825a4"
      //     container_name   = "ecs-sample"
      //     container_port   = 8000
      //   }
      // }

      subnet_ids = ["subnet-0c3b52af38f256786", "subnet-075f694a8b04ef458", "subnet-0d1d822b8d8ca2950"]
      security_group_rules = {
        alb_ingress_8000 = {
          type                     = "ingress"
          from_port                = 80
          to_port                  = 8000
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = "sg-05e32b253d35ed751"
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