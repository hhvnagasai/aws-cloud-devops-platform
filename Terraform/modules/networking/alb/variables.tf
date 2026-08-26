variable "name" {
  description = "Name of the Application Load Balancer"
  type        = string
}


variable "subnet_ids" {
  description = "Public subnet IDs where the Application Load Balancer will be deployed"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnets are required for the Application Load Balancer."
  }
}

variable "security_group_ids" {
  description = "Security group IDs associated with the Application Load Balancer"
  type        = list(string)
}

variable "internal" {
  description = "Whether the Application Load Balancer is internal"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the Application Load Balancer resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where the Application Load Balancer and target groups will be deployed"
  type        = string
}

variable "target_groups" {
  description = "Target group configuration for ECS microservices"

  type = map(object({
    port              = number
    protocol          = string
    target_type       = string
    health_check_path = string
  }))
}
