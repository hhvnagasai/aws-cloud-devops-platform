#------------------------------------------
# AWS Configuration
#------------------------------------------

variable "aws_region" {
  description = "AWS Region."
  type        = string
  nullable    = false
}


#------------------------------------------
# VPC Configuration
#------------------------------------------

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  nullable    = false
}


variable "enable_dns_support" {
  description = "Enable DNS support."
  type        = bool
  nullable    = false
}


variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames."
  type        = bool
  nullable    = false
}


#------------------------------------------
# Subnet Configuration
#------------------------------------------

variable "public_subnets" {

  description = "Public subnet configuration."

  type = list(object({

    name                    = string
    cidr                    = string
    az                      = string
    map_public_ip_on_launch = bool

  }))

  nullable = false

}


variable "private_subnets" {

  description = "Private subnet configuration."

  type = list(object({

    name = string
    cidr = string
    az   = string

  }))

  nullable = false

}


#------------------------------------------
# NAT Gateway Configuration
#------------------------------------------

variable "nat_gateways" {

  description = "NAT Gateway configuration."

  type = list(object({

    name      = string
    subnet_id = string

  }))

  nullable = false

}


#------------------------------------------
# Route Table Configuration
#------------------------------------------

variable "route_tables" {

  description = "Route table configuration."

  type = list(object({

    name = string

  }))

  nullable = false

}


variable "routes" {

  description = "Routes configuration."

  type = list(object({

    name                   = string
    route_table_name       = string
    destination_cidr_block = string
    gateway_id             = optional(string)
    nat_gateway_id         = optional(string)

  }))

  nullable = false

}


variable "route_table_associations" {

  description = "Route table association configuration."

  type = list(object({

    name             = string
    subnet_id        = string
    route_table_name = string

  }))
  nullable = false

}

#################################################
# KMS Variables
#################################################

variable "kms_description" {
  description = "Description for the Customer Managed KMS Key."
  type        = string
}

variable "kms_alias_name" {
  description = "Alias name for the Customer Managed KMS Key."
  type        = string
}

variable "kms_enable_key_rotation" {
  description = "Enable automatic rotation for the KMS Key."
  type        = bool
  default     = true
}

variable "kms_deletion_window_in_days" {
  description = "Number of days before a scheduled KMS Key deletion."
  type        = number
  default     = 30

  validation {
    condition     = var.kms_deletion_window_in_days >= 7 && var.kms_deletion_window_in_days <= 30
    error_message = "KMS deletion window must be between 7 and 30 days."
  }
}

#-----------------------------------
# Common Tags
#------------------------------------------

variable "common_tags" {

  description = "Common tags for AWS resources."

  type     = map(string)
  nullable = false

}
#################################################
# VPC Endpoint Configuration
#################################################

variable "gateway_endpoints" {
  description = "Gateway VPC Endpoints to create."
  type        = list(string)
  default     = []
}

variable "interface_endpoints" {
  description = "Interface VPC Endpoints to create."
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "Whether to create a Security Group for Interface Endpoints."
  type        = bool
  default     = true
}

variable "security_group_name" {
  description = "Security Group name for Interface Endpoints."
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access Interface Endpoints."
  type        = list(string)
}

variable "endpoint_policy" {
  description = "Optional endpoint policy."
  type        = string
  default     = null
}
#################################################
# Secrets Manager Variables
#################################################

variable "secret_name" {
  description = "Name of the Secrets Manager secret."
  type        = string
  nullable    = false
}

variable "secret_description" {
  description = "Description of the Secrets Manager secret."
  type        = string
  nullable    = false
}

variable "secret_recovery_window_in_days" {
  description = "Recovery window before the secret is permanently deleted."
  type        = number
  default     = 30

  validation {
    condition     = var.secret_recovery_window_in_days >= 7 && var.secret_recovery_window_in_days <= 30
    error_message = "Recovery window must be between 7 and 30 days."
  }
}
#################################################
# Amazon ECR
#################################################

variable "ecr_repositories" {
  description = "Names of ECR repositories for deployable application services."
  type        = set(string)
}
#################################################
# ECS Configuration
#################################################

variable "cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.cluster_name)) > 0
    error_message = "cluster_name must not be empty."
  }
}

variable "container_insights_enabled" {
  description = "Whether ECS Container Insights is enabled."
  type        = bool
  default     = true
}

#--------------------------------------------------
# Security Group Configuration
#--------------------------------------------------

variable "security_groups" {
  description = "Security group definitions for the development environment."

  type = map(object({
    name        = string
    description = string

    ingress_rules = list(object({
      description       = string
      protocol          = string
      from_port         = number
      to_port           = number
      cidr_blocks       = optional(list(string), [])
      source_group_name = optional(string)
    }))

    egress_rules = list(object({
      description = string
      protocol    = string
      from_port   = number
      to_port     = number
      cidr_blocks = optional(list(string), [])
    }))
  }))

  nullable = false
}

#--------------------------------------------------
# Application Load Balancer Configuration
#--------------------------------------------------

variable "alb_name" {
  description = "Name of the Application Load Balancer."
  type        = string
  nullable    = false
}

variable "alb_internal" {
  description = "Whether the Application Load Balancer is internal."
  type        = bool
  default     = false
}

#--------------------------------------------------
# ALB Target Group Configuration
#--------------------------------------------------

variable "alb_target_groups" {
  description = "Target groups for the Application Load Balancer."

  type = map(object({
    port              = number
    protocol          = string
    target_type       = string
    health_check_path = string
  }))

  nullable = false
}
#--------------------------------------------------
# RDS MySQL Configuration
#--------------------------------------------------

variable "rds_engine_version" {
  description = "MySQL engine version for the development RDS instance."
  type        = string
  nullable    = false
}

variable "rds_instance_class" {
  description = "RDS instance class for the development database."
  type        = string
  nullable    = false
}

variable "rds_allocated_storage" {
  description = "Initial RDS storage allocation in GB for the development database."
  type        = number
  nullable    = false
}

variable "rds_backup_retention_period" {
  description = "Number of days automated RDS backups are retained in the development environment."
  type        = number
  nullable    = false
}

variable "rds_deletion_protection" {
  description = "Whether deletion protection is enabled for the development RDS instance."
  type        = bool
  nullable    = false
}
#################################################
# ECS Service Configuration
#################################################

variable "gateway_task_cpu" {
  description = "CPU units allocated to the gateway ECS task."
  type        = number
  default     = 512
}

variable "gateway_task_memory" {
  description = "Memory in MiB allocated to the gateway ECS task."
  type        = number
  default     = 1024
}

variable "gateway_desired_count" {
  description = "Number of gateway ECS tasks."
  type        = number
  default     = 1
}
