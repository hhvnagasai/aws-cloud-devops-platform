#################################################
# Core Infrastructure Variables
#################################################

variable "vpc_id" {
  description = "The ID of the VPC where the endpoints will be created."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Interface VPC Endpoints."
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "List of private route table IDs for Gateway VPC Endpoints."
  type        = list(string)
}

#################################################
# Gateway Endpoint Configuration
#################################################

variable "gateway_endpoints" {
  description = "List of Gateway Endpoints to create."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for endpoint in var.gateway_endpoints :
      contains(["s3", "dynamodb"], lower(endpoint))
    ])
    error_message = "Supported Gateway Endpoints are s3 and dynamodb."
  }
}

#################################################
# Interface Endpoint Configuration
#################################################

variable "interface_endpoints" {
  description = "List of Interface Endpoints to create."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for endpoint in var.interface_endpoints :
      contains([
        "ecr.api",
        "ecr.dkr",
        "ssm",
        "ssmmessages",
        "ec2messages",
        "logs",
        "secretsmanager"
      ], lower(endpoint))
    ])
    error_message = "One or more Interface Endpoints are invalid."
  }
}

#################################################
# Security Group Configuration
#################################################

variable "create_security_group" {
  description = "Whether to create a Security Group for Interface Endpoints."
  type        = bool
  default     = true
}

variable "security_group_name" {
  description = "Security Group name."
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the Interface Endpoints."
  type        = list(string)
}

variable "security_group_id" {
  description = "Existing Security Group ID if create_security_group is false."
  type        = string
  default     = null
}

#################################################
# Endpoint Policy
#################################################

variable "endpoint_policy" {
  description = "Optional Endpoint Policy."
  type        = string
  default     = null
}

#################################################
# Common Tags
#################################################

variable "tags" {
  description = "Common tags."
  type        = map(string)
}
