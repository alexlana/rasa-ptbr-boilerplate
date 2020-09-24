resource "aws_cloudwatch_log_group" "boilerplate_web" {
  name              = "boilerplate_web"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "boilerplate_web" {
  family = "boilerplate_web"

  container_definitions = <<EOF
[
  {
    "name": "boilerplate_web",
    "image": "hello-world",
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "sa-east-1",
        "awslogs-group": "boilerplate_actions",
        "awslogs-stream-prefix": "boilerplate"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "boilerplate_web" {
  name            = "boilerplate_web"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.boilerplate_web.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}