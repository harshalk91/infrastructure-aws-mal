variable "name" {
  type    = string
  default = "java-ecs"
}

variable "vpc_id" {
  type = string
  default = "vpc-123456"
}

variable "container_port" {
  type    = number
  default = 8080
}