variable "log_group_name" {
  description = "Name of the CloudWatch Log Group."
  type        = string

  validation {
    condition     = length(trimspace(var.log_group_name)) > 0
    error_message = "log_group_name must not be empty."
  }
}

variable "retention_in_days" {
  description = "Number of days CloudWatch logs are retained."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days > 0
    error_message = "retention_in_days must be greater than zero."
  }
}

variable "common_tags" {
  description = "Common tags applied to the CloudWatch Log Group."
  type        = map(string)
  default     = {}
}
