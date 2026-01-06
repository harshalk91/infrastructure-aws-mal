variable "name" {
  type    = string
  default = "java-ecs"
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "alb_sg_id" {
  type = string
}

