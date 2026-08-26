variable "db_identifier" {
  description = "Unique identifier for the RDS DB instance."
  type        = string
  nullable    = false
}

variable "db_name" {
  description = "Name of the application database."
  type        = string
  nullable    = false
}

variable "master_username" {
  description = "Master username for the RDS DB instance."
  type        = string
  nullable    = false
}

variable "engine_version" {
  description = "MySQL engine version for the RDS DB instance."
  type        = string
  nullable    = false
}

variable "instance_class" {
  description = "RDS DB instance class."
  type        = string
  nullable    = false
}

variable "allocated_storage" {
  description = "Initial storage allocated to the RDS DB instance in GB."
  type        = number
  nullable    = false
}

variable "port" {
  description = "Port used by the RDS database."
  type        = number
  nullable    = false
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the RDS DB subnet group."
  type        = list(string)
  nullable    = false
}

variable "security_group_ids" {
  description = "Security group IDs attached to the RDS DB instance."
  type        = list(string)
  nullable    = false
}

variable "kms_key_arn" {
  description = "ARN of the customer-managed KMS key used for RDS encryption."
  type        = string
  nullable    = false
}

variable "backup_retention_period" {
  description = "Number of days automated RDS backups are retained."
  type        = number
  nullable    = false
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the RDS DB instance."
  type        = bool
  nullable    = false
}

variable "common_tags" {
  description = "Common tags applied to RDS resources."
  type        = map(string)
  nullable    = false
}
