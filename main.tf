# Root Terraform configuration
# Orchestrates modules for ECS Fargate deployment

module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "ecr" {
  source = "./modules/ecr"

  project_name         = var.project_name
  environment          = var.environment
  image_tag_mutability = var.ecr_image_tag_mutability
  scan_on_push         = var.ecr_scan_on_push
  encryption_type      = var.ecr_encryption_type
  kms_key_arn          = var.ecr_kms_key_arn
  max_image_count      = var.ecr_max_image_count
  untagged_image_days  = var.ecr_untagged_image_days
}

module "iam" {
  source = "./modules/iam"

  project_name        = var.project_name
  environment         = var.environment
  ecr_repository_arns = [module.ecr.repository_arn]
}

module "ecs" {
  source = "./modules/ecs"

  project_name                       = var.project_name
  environment                        = var.environment
  subnet_ids                         = module.network.private_subnet_ids
  ecs_security_group_id              = module.network.ecs_security_group_id
  assign_public_ip                   = false
  task_execution_role_arn            = module.iam.task_execution_role_arn
  task_role_arn                      = module.iam.task_role_arn
  ecr_repository_url                 = module.ecr.repository_url
  container_image_tag                = "latest"
  container_name                     = "app"
  container_port                     = 8080
  container_environment_variables    = []
  task_cpu                           = "256"
  task_memory                        = "512"
  desired_count                      = 1
  launch_type                        = "FARGATE"
  health_check_command               = ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
  health_check_interval              = 30
  health_check_timeout               = 5
  health_check_retries               = 3
  health_check_start_period          = 60
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  enable_deployment_circuit_breaker  = true
  enable_deployment_rollback         = true
  log_retention_days                 = 3
  enable_container_insights          = false
  aws_region                         = data.aws_region.current
}
