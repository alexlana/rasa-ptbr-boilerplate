locals {
  name        = "boilerplate-ecs"
  environment = "dev"
  region      = "sa-east-1"

  # This is the convention we use to know what belongs to each other
  ec2_resources_name = "${local.name}-${local.environment}"
}