variable "cluster_arn" {
  description = "ARN of the ECS cluster."
  type        = string

  validation {
    condition     = length(trimspace(var.cluster_arn)) > 0
    error_message = "cluster_arn must not be empty."
  }
}

variable "service_name" {
  description = "Name of the ECS service."
  type        = string

  validation {
    condition     = length(trimspace(var.service_name)) > 0
    error_message = "service_name must not be empty."
  }
}

variable "task_definition_name" {
  description = "Family name of the ECS task definition."
  type        = string

  validation {
    condition     = length(trimspace(var.task_definition_name)) > 0
    error_message = "task_definition_name must not be empty."
  }
}

variable "container_name" {
  description = "Name of the container."
  type        = string

  validation {
    condition     = length(trimspace(var.container_name)) > 0
    error_message = "container_name must not be empty."
  }
}

variable "image" {
  description = "Container image URI."
  type        = string

  validation {
    condition     = length(trimspace(var.image)) > 0
    error_message = "image must not be empty."
  }
}

variable "task_cpu" {
  description = "CPU units allocated to the Fargate task."
  type        = number

  validation {
    condition     = var.task_cpu > 0
    error_message = "task_cpu must be greater than 0."
  }
}

variable "task_memory" {
  description = "Memory in MiB allocated to the Fargate task."
  type        = number

  validation {
    condition     = var.task_memory > 0
    error_message = "task_memory must be greater than 0."
  }
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535
    error_message = "container_port must be between 1 and 65535."
  }
}

variable "desired_count" {
  description = "Number of desired ECS tasks."
  type        = number

  validation {
    condition     = var.desired_count >= 1
    error_message = "desired_count must be at least 1."
  }
}

variable "subnet_ids" {
  description = "Private subnet IDs where ECS tasks will run."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs must be provided."
  }
}

variable "security_group_ids" {
  description = "Security groups attached to ECS tasks."
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) >= 1
    error_message = "At least one security group ID must be provided."
  }
}

variable "target_group_arn" {
  description = "ARN of the ALB target group."
  type        = string
  default     = null
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution IAM role."
  type        = string

  validation {
    condition     = length(trimspace(var.execution_role_arn)) > 0
    error_message = "execution_role_arn must not be empty."
  }
}

variable "task_role_arn" {
  description = "ARN of the ECS task IAM role."
  type        = string
  default     = null

}

variable "log_group_name" {
  description = "CloudWatch Logs group name for the container."
  type        = string

  validation {
    condition     = length(trimspace(var.log_group_name)) > 0
    error_message = "log_group_name must not be empty."
  }
}

variable "aws_region" {
  description = "AWS region where the ECS service is deployed."
  type        = string

  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region must not be empty."
  }
}
variable "common_tags" {
  description = "Common tags applied to ECS resources."
  type        = map(string)
  default     = {}
}
variable "service_connect_enabled" {
  description = "Whether ECS Service Connect is enabled for the service."
  type        = bool
  default     = false
}

variable "service_connect_port_name" {
  description = "Port mapping name used by ECS Service Connect."
  type        = string
  default     = "http"
}
variable "service_connect_namespace" {
  description = "Cloud Map namespace used by ECS Service Connect."
  type        = string
  default     = null
}
variable "environment_variables" {
  description = "Environment variables passed to the ECS container."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
variable "secrets" {
  description = "Secrets injected into the ECS container from AWS Secrets Manager."
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}
