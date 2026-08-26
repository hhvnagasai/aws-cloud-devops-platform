#############################################
# Amazon ECR Repository Variables
#############################################

variable "repository_name" {
  description = "Name of the Amazon ECR repository."
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the customer-managed AWS KMS key used to encrypt the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for the repository."

  type    = string
  default = "IMMUTABLE"

  validation {
    condition = contains(
      ["MUTABLE", "IMMUTABLE"],
      var.image_tag_mutability
    )

    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable basic image scanning when an image is pushed."

  type    = bool
  default = true
}

variable "lifecycle_max_image_count" {
  description = "Maximum number of images to retain in the repository."

  type    = number
  default = 30

  validation {
    condition     = var.lifecycle_max_image_count > 0
    error_message = "lifecycle_max_image_count must be greater than zero."
  }
}

variable "common_tags" {
  description = "Common tags applied to all resources."

  type = map(string)
}

