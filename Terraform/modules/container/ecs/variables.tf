variable "cluster_name" {
  description = "Name of the ECS cluster."
  type        = string

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

variable "common_tags" {
  description = "Common tags applied to ECS resources."
  type        = map(string)
  default     = {}
}
