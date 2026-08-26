variable "nat_gateways" {

  description = "List of NAT Gateway configurations."

  type = list(object({

    name      = string
    subnet_id = string

  }))

  nullable = false

}



variable "common_tags" {

  description = "Common tags for AWS resources."
  type        = map(string)
  nullable    = false

}
