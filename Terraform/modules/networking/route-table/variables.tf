variable "vpc_id" {
  description = "VPC ID."
  type        = string
  nullable    = false
}



variable "route_tables" {

  type = list(object({

    name = string

  }))

}



variable "routes" {

  type = list(object({

    name                   = string
    route_table_name       = string
    destination_cidr_block = string
    gateway_id             = optional(string)
    nat_gateway_id         = optional(string)

  }))

}



variable "route_table_associations" {

  type = list(object({

    name             = string
    subnet_id        = string
    route_table_name = string

  }))

}



variable "common_tags" {

  type     = map(string)
  nullable = false

}
