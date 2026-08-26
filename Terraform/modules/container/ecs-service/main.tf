resource "aws_ecs_task_definition" "this" {
  family                   = var.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = var.task_cpu
  memory = var.task_memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name        = var.container_name
      image       = var.image
      essential   = true
      environment = var.environment_variables
      secrets     = var.secrets
      portMappings = [
        {
          name          = var.service_connect_port_name
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.service_name
        }
      }
    }
  ])

  tags = merge(
    var.common_tags,
    {
      Name = var.task_definition_name
    }
  )
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }
  dynamic "service_connect_configuration" {
    for_each = var.service_connect_enabled ? [1] : []

    content {
      enabled   = true
      namespace = var.service_connect_namespace

      service {
        port_name      = var.service_connect_port_name
        discovery_name = var.service_name
        client_alias {
          dns_name = var.service_name
          port     = var.container_port
        }
      }
    }
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn != null ? [1] : []

    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.service_name
    }
  )
}
