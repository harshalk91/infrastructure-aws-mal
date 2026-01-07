variable "cluster_name" {
  type = string
}

variable "name" {
  type    = string
  default = "java-ecs"
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "cpu" {
  type    = number
  default = 512
}

variable "memory" {
  type    = number
  default = 1024
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "log_group_name" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "private_subnets" {
  type = list(string)
}

variable "ecr_repository_url" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}