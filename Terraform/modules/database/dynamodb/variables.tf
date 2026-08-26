variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
  nullable    = false
}

variable "common_tags" {
  description = "Common tags for all AWS resources."
  type        = map(string)
  nullable    = false
}
