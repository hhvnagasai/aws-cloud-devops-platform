variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
  nullable    = false
}


variable "public_subnets" {

  description = "List of public subnet configurations."

  type = list(object({

    name                    = string
    cidr                    = string
    az                      = string
    map_public_ip_on_launch = bool

  }))

  nullable = false

}


variable "private_subnets" {

  description = "List of private subnet configurations."

  type = list(object({

    name = string
    cidr = string
    az   = string

  }))

  nullable = false

}


variable "common_tags" {

  description = "Common tags for AWS resources."
  type        = map(string)
  nullable    = false

}
