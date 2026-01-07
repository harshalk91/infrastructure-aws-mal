locals {
  common_tags = {
    project = var.name
    environment = var.environment
  }
}

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-${var.environment}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "java-app"
      image = "${var.ecr_repository_url}@${var.environment}"
      portMappings = [{
        containerPort = var.container_port
        protocol      = "tcp"
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  tags = local.common_tags
}

resource "aws_ecs_service" "this" {
  name            = "${var.name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_sg_id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "java-app"
    container_port   = var.container_port
  }

  tags = local.common_tags
}


resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = 3
  min_capacity       = 1
    resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  tags = local.common_tags
}

resource "aws_appautoscaling_policy" "cpu_target" {
  name               = "${var.name}-${var.environment}-cpu-70"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}