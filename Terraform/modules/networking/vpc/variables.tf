variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  nullable    = false
}


variable "enable_dns_support" {
  description = "Enable DNS support for the VPC."
  type        = bool
  nullable    = false
}


variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC."
  type        = bool
  nullable    = false
}


variable "common_tags" {
  description = "Common tags for all AWS resources."
  type        = map(string)
  nullable    = false
}
