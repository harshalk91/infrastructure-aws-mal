locals {
  common_tags = {
    project = var.name
  }
}

resource "aws_ecr_repository" "app" {
  name                 = "${var.name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.common_tags
}
