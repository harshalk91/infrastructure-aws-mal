module "vpc" {
  source = "./modules/vpc"
  name = var.name
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment = var.environment
}

module "security_group" {
  source = "./modules/security_groups"
  name = var.name
  vpc_id = module.vpc.vpc_id
  container_port = var.container_port
  environment = var.environment
}

module "alb" {
  source = "./modules/alb"

  alb_sg_id      = module.security_group.alb_security_group_id
  vpc_id         = module.vpc.vpc_id
  public_subnets = var.private_subnet_cidrs
  container_port = var.container_port
  environment = var.environment
}

module "ecr" {
  source = "./modules/ecr"
  name = var.name
}

module "logs" {
  source = "./modules/cloudwatch"
  name = var.name
  environment = var.environment
}

module "iam" {
  source = "./modules/iam"
  name = var.name
  environment = var.environment
}

module "ecs" {
  source = "./modules/ecs"
  cluster_name = var.name
  execution_role_arn = module.iam.task_execution_role_arn
  log_group_name = var.name
  private_subnets = var.private_subnet_cidrs
  task_role_arn = module.iam.task_role_arn
  ecr_repository_url = module.ecr.ecr_repository_url
  cpu = var.cpu
  memory = var.memory
  container_port = var.container_port
  target_group_arn = module.alb.target_group_arn
  ecs_sg_id = module.security_group.ecs_security_group_id
  aws_region = var.aws_region
  environment = var.environment
}

