variable "secret_name" {
  description = "Name of the Secrets Manager secret."
  type        = string
}

variable "description" {
  description = "Description of the Secrets Manager secret."
  type        = string
}

variable "kms_key_id" {
  description = "Customer Managed KMS Key ID or ARN used to encrypt the secret."
  type        = string
}

variable "recovery_window_in_days" {
  description = "Number of days Secrets Manager waits before permanently deleting the secret."
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30
    error_message = "Recovery window must be between 7 and 30 days."
  }
}

variable "common_tags" {
  description = "Common tags applied to the Secrets Manager secret."
  type        = map(string)
  nullable    = false
}
