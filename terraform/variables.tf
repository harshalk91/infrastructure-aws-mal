variable "name" {
  type    = string
  default = "java-ecs"
}

variable "aws_region" {
  type    = string
  default = "me-central-1"
}


variable "vpc_cidr" {
  type    = string
  default = "10.50.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.50.0.0/24", "10.50.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.50.15.0/24", "10.20.16.0/24"]
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "cpu" {
  type    = number
  default = 512
}

variable "memory" {
  type    = number
  default = 1024
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "image_tag" {
  type    = string
  default = "latest"
}


variable "log_retention_days" {
  type    = number
  default = 7
}