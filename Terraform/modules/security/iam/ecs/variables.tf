variable "execution_role_name" {
  description = "Name of the ECS task execution IAM role."
  type        = string
  nullable    = false
}

variable "task_role_name" {
  description = "Name of the ECS task IAM role."
  type        = string
  nullable    = false
}

variable "secrets_arns" {
  description = "ARNs of Secrets Manager secrets that ECS tasks are allowed to retrieve."
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used to decrypt ECS task secrets."
  type        = string
  nullable    = false
}

variable "common_tags" {
  description = "Common tags for AWS resources."
  type        = map(string)
  nullable    = false
}
