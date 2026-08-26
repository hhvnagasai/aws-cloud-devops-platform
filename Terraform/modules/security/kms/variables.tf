variable "description" {
  description = "Description of the Customer Managed KMS Key."
  type        = string
}

variable "alias_name" {
  description = "Alias name for the KMS Key."
  type        = string
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation."
  type        = bool
  default     = true
}

variable "deletion_window_in_days" {
  description = "Waiting period before the KMS Key is permanently deleted."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to be applied to the KMS Key."
  type        = map(string)
  default     = {}
}
