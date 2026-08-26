variable "name" {
  description = "Name of the ECS Service Connect namespace."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "Namespace name must not be empty."
  }
}

variable "description" {
  description = "Description of the ECS Service Connect namespace."
  type        = string
  default     = "ECS Service Connect namespace."
}

variable "common_tags" {
  description = "Common tags applied to the namespace."
  type        = map(string)
  default     = {}
}
