locals {
  common_tags = {
    project = var.name
    environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.name}-${var.environment}"
  retention_in_days = var.log_retention_days
  tags              = local.common_tags
}