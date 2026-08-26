variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
  nullable    = false
}


variable "common_tags" {
  description = "Common tags for AWS resources."
  type        = map(string)
  nullable    = false
}
