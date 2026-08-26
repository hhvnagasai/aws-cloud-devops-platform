variable "vpc_id" {
  description = "VPC ID where the security groups will be created."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "vpc_id must not be empty."
  }
}

variable "security_groups" {
  description = "Security group definitions."

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

  validation {
    condition = alltrue([
      for group in values(var.security_groups) :
      alltrue([
        for rule in group.ingress_rules :
        (
          length(rule.cidr_blocks) > 0
          && rule.source_group_name == null
        )
        ||
        (
          length(rule.cidr_blocks) == 0
          && rule.source_group_name != null
          && length(trimspace(rule.source_group_name)) > 0
        )
      ])
    ])

    error_message = "Each ingress rule must define either cidr_blocks or source_group_name, but not both."
  }

  validation {
    condition = alltrue([
      for group in values(var.security_groups) :
      alltrue([
        for rule in group.egress_rules :
        length(rule.cidr_blocks) > 0
      ])
    ])

    error_message = "Each egress rule must contain at least one CIDR block."
  }

  validation {
    condition     = length(var.security_groups) > 0
    error_message = "At least one security group must be defined."
  }
}

variable "common_tags" {
  description = "Common tags applied to security groups."
  type        = map(string)
  default     = {}
}
