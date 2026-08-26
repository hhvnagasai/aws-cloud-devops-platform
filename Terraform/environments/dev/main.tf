module "vpc" {

  source = "../../modules/networking/vpc"

  vpc_cidr             = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  common_tags          = var.common_tags

}
module "subnet" {

  source = "../../modules/networking/subnet"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  common_tags     = var.common_tags

}
module "igw" {

  source = "../../modules/networking/igw"

  vpc_id      = module.vpc.vpc_id
  common_tags = var.common_tags

}

module "nat" {

  source = "../../modules/networking/nat"

  nat_gateways = [
    {
      name      = var.nat_gateways[0].name
      subnet_id = module.subnet.public_subnet_ids[0]
    }
  ]

  common_tags = var.common_tags

}


module "route_table" {

  source = "../../modules/networking/route-table"

  vpc_id = module.vpc.vpc_id

  route_tables = var.route_tables

  routes = [

    {
      name                   = "public-internet-route"
      route_table_name       = "public-route-table"
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = module.igw.igw_id
    },

    {
      name                   = "private-nat-route"
      route_table_name       = "private-route-table"
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = module.nat.nat_gateway_ids[0]
    }

  ]

  route_table_associations = [

    {
      name             = "public-subnet-a-association"
      subnet_id        = module.subnet.public_subnet_ids[0]
      route_table_name = "public-route-table"
    },

    {
      name             = "public-subnet-b-association"
      subnet_id        = module.subnet.public_subnet_ids[1]
      route_table_name = "public-route-table"
    },

    {
      name             = "private-subnet-a-association"
      subnet_id        = module.subnet.private_subnet_ids[0]
      route_table_name = "private-route-table"
    },

    {
      name             = "private-subnet-b-association"
      subnet_id        = module.subnet.private_subnet_ids[1]
      route_table_name = "private-route-table"
    }

  ]

  common_tags = var.common_tags

}
# ==============================
# Security Modules
# ==============================

module "kms" {
  source = "../../modules/security/kms"

  description             = var.kms_description
  alias_name              = var.kms_alias_name
  enable_key_rotation     = var.kms_enable_key_rotation
  deletion_window_in_days = var.kms_deletion_window_in_days

  tags = var.common_tags
}
#################################################
# Secrets Manager
#################################################

module "secrets_manager" {
  source = "../../modules/shared-services/secrets-manager"

  secret_name             = var.secret_name
  description             = var.secret_description
  kms_key_id              = module.kms.key_id
  recovery_window_in_days = var.secret_recovery_window_in_days

  common_tags = var.common_tags
}
#################################################
# ECS IAM
#################################################

module "ecs_iam" {
  source = "../../modules/security/iam/ecs"

  execution_role_name = "dev-ecs-task-execution-role"
  task_role_name      = "dev-ecs-task-role"

  secrets_arns = [
    module.rds.master_user_secret_arn
  ]

  kms_key_arn = module.kms.key_arn

  common_tags = var.common_tags
}
#################################################
# Amazon ECR
#################################################

module "ecr" {
  for_each = var.ecr_repositories

  source = "../../modules/container/ecr"

  repository_name = each.value
  kms_key_arn     = module.kms.key_arn

  common_tags = var.common_tags
}
#################################################
# Amazon ECS
#################################################

module "ecs" {
  source = "../../modules/container/ecs"

  cluster_name               = var.cluster_name
  container_insights_enabled = var.container_insights_enabled
  common_tags                = var.common_tags
}
#################################################
# VPC Endpoints
#################################################

# module "vpc_endpoint" {
#
#   source = "../../modules/networking/vpc-endpoint"
#
#   vpc_id                  = module.vpc.vpc_id
#   private_subnet_ids      = module.subnet.private_subnet_ids
#   private_route_table_ids = module.route_table.private_route_table_ids
#
#   gateway_endpoints   = var.gateway_endpoints
#   interface_endpoints = var.interface_endpoints
#
#   create_security_group = var.create_security_group
#   security_group_name   = var.security_group_name
#   allowed_cidr_blocks   = var.allowed_cidr_blocks
#
#   endpoint_policy = var.endpoint_policy
#
#   tags = local.common_tags
# }

#--------------------------------------------------
# Security Groups
#--------------------------------------------------

module "security_groups" {
  source = "../../modules/security/security-groups"

  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
  common_tags     = var.common_tags
}

#--------------------------------------------------
# Amazon RDS MySQL
#--------------------------------------------------

module "rds" {
  source = "../../modules/database/rds"

  db_identifier = "dev-crm-db"
  db_name       = "crm"

  master_username = "devadmin"

  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class

  allocated_storage = var.rds_allocated_storage
  port              = 3306

  private_subnet_ids = module.subnet.private_subnet_ids

  security_group_ids = [
    module.security_groups.security_group_ids["rds"]
  ]

  kms_key_arn = module.kms.key_arn

  backup_retention_period = var.rds_backup_retention_period
  deletion_protection     = var.rds_deletion_protection

  common_tags = var.common_tags
}
#--------------------------------------------------
# Application Load Balancer
#--------------------------------------------------

module "alb" {
  source = "../../modules/networking/alb"

  name               = var.alb_name
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.subnet.public_subnet_ids
  security_group_ids = [module.security_groups.security_group_ids["alb"]]
  internal           = var.alb_internal
  target_groups      = var.alb_target_groups
  tags               = var.common_tags
}
#################################################
# CloudWatch Logs - Gateway Service
#################################################

module "gateway_logs" {
  source = "../../modules/monitoring/cloudwatch"

  log_group_name    = "/ecs/dev/gateway-service"
  retention_in_days = 30

  common_tags = var.common_tags
}
#################################################
# CloudWatch Logs - Auth Service
#################################################

module "auth_logs" {
  source = "../../modules/monitoring/cloudwatch"

  log_group_name    = "/ecs/dev/auth-service"
  retention_in_days = 30

  common_tags = var.common_tags
}
#################################################
# CloudWatch Logs - User Service
#################################################

module "user_logs" {
  source = "../../modules/monitoring/cloudwatch"

  log_group_name    = "/ecs/dev/user-service"
  retention_in_days = 30

  common_tags = var.common_tags
}
#################################################
# ECS Service Connect Namespace
#################################################

module "service_connect_namespace" {
  source = "../../modules/container/service-connect-namespace"

  name        = "dev-service-connect"
  description = "Service Connect namespace for dev ECS services."

  common_tags = var.common_tags
}
#################################################
# ECS Gateway Service
#################################################

module "gateway_service" {
  source = "../../modules/container/ecs-service"

  cluster_arn          = module.ecs.cluster_arn
  service_name         = "gateway-service"
  task_definition_name = "dev-gateway-service"

  container_name = "gateway-service"

  image = "${module.ecr["gateway-service"].repository_url}:dev"

  task_cpu    = var.gateway_task_cpu
  task_memory = var.gateway_task_memory

  container_port = 8080
  desired_count  = var.gateway_desired_count

  service_connect_enabled   = true
  service_connect_port_name = "http"
  service_connect_namespace = module.service_connect_namespace.name

  subnet_ids = module.subnet.private_subnet_ids

  security_group_ids = [
    module.security_groups.security_group_ids["ecs"]
  ]

  target_group_arn = module.alb.target_group_arns["gateway-service"]

  execution_role_arn = module.ecs_iam.task_execution_role_arn
  task_role_arn      = module.ecs_iam.task_role_arn

  log_group_name = module.gateway_logs.log_group_name
  aws_region     = var.aws_region

  common_tags = var.common_tags
}
#################################################
# ECS Auth Service
#################################################

module "auth_service" {
  source = "../../modules/container/ecs-service"

  cluster_arn          = module.ecs.cluster_arn
  service_name         = "auth-service"
  task_definition_name = "dev-auth-service"

  container_name = "auth-service"

  image = "${module.ecr["auth-service"].repository_url}:8e7e0c682543"

  task_cpu    = var.gateway_task_cpu
  task_memory = var.gateway_task_memory

  container_port = 8081
  desired_count  = 1

  service_connect_enabled   = true
  service_connect_port_name = "http"
  service_connect_namespace = module.service_connect_namespace.name

  subnet_ids = module.subnet.private_subnet_ids

  security_group_ids = [
    module.security_groups.security_group_ids["ecs"]
  ]

  target_group_arn = null

  execution_role_arn = module.ecs_iam.task_execution_role_arn
  task_role_arn      = module.ecs_iam.task_role_arn

  log_group_name = module.auth_logs.log_group_name
  aws_region     = var.aws_region
  environment_variables = [
    {
      name  = "DB_HOST"
      value = module.rds.db_endpoint
    },
    {
      name  = "DB_PORT"
      value = tostring(module.rds.db_port)
    },
    {
      name  = "SPRING_DATASOURCE_USERNAME"
      value = "devadmin"
    }
  ]
  secrets = [
    {
      name      = "SPRING_DATASOURCE_PASSWORD"
      valueFrom = "${module.rds.master_user_secret_arn}:password::"
    }
  ]
  common_tags = var.common_tags
}
#################################################
# ECS User Service
#################################################

module "user_service" {
  source = "../../modules/container/ecs-service"

  cluster_arn          = module.ecs.cluster_arn
  service_name         = "user-service"
  task_definition_name = "dev-user-service"

  container_name = "user-service"

  image = "${module.ecr["user-service"].repository_url}:dev"

  task_cpu    = var.gateway_task_cpu
  task_memory = var.gateway_task_memory

  container_port = 8082
  desired_count  = 1

  service_connect_enabled   = true
  service_connect_port_name = "http"
  service_connect_namespace = module.service_connect_namespace.name

  subnet_ids = module.subnet.private_subnet_ids

  security_group_ids = [
    module.security_groups.security_group_ids["ecs"]
  ]

  target_group_arn = null

  execution_role_arn = module.ecs_iam.task_execution_role_arn
  task_role_arn      = module.ecs_iam.task_role_arn

  log_group_name = module.user_logs.log_group_name
  aws_region     = var.aws_region

  environment_variables = [
    {
      name  = "DB_HOST"
      value = module.rds.db_endpoint
    },
    {
      name  = "DB_PORT"
      value = tostring(module.rds.db_port)
    },
    {
      name  = "SPRING_DATASOURCE_USERNAME"
      value = "devadmin"
    }
  ]

  secrets = [
    {
      name      = "SPRING_DATASOURCE_PASSWORD"
      valueFrom = "${module.rds.master_user_secret_arn}:password::"
    }
  ]

  common_tags = var.common_tags
}
