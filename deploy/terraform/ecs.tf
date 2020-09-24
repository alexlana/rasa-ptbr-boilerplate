#----- ECS --------
module "ecs" {
  source             = "terraform-aws-modules/ecs/aws"
  name               = local.name
  container_insights = true
}

module "ec2-profile" {
  source = "./modules/ecs-instance-profile"
  name   = local.name
}

#----- ECS  Services--------

module "service-actions" {
  source     = "./service-actions"
  cluster_id = module.ecs.this_ecs_cluster_id
}

module "service-web" {
  source     = "./service-web"
  cluster_id = module.ecs.this_ecs_cluster_id
}


module "this" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = local.ec2_resources_name

  # Launch configuration
  lc_name = local.ec2_resources_name

  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = "t2.micro"
  security_groups      = [module.vpc.default_security_group_id]
  iam_instance_profile = module.ec2-profile.this_iam_instance_profile_id
  user_data            = data.template_file.user_data.rendered

  # Auto scaling group
  asg_name                  = local.ec2_resources_name
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = local.environment
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = local.name
      propagate_at_launch = true
    },
  ]
}
