#################################################
# Security Group Outputs
#################################################

output "security_group_id" {
  description = "Security Group ID used by Interface VPC Endpoints."

  value = (
    var.create_security_group ?
    aws_security_group.vpc_endpoint[0].id :
    var.security_group_id
  )
}

#################################################
# Gateway Endpoint Outputs
#################################################

output "gateway_endpoint_ids" {
  description = "Map of Gateway Endpoint IDs."

  value = {
    for name, endpoint in aws_vpc_endpoint.gateway :
    name => endpoint.id
  }
}

#################################################
# Interface Endpoint Outputs
#################################################

output "interface_endpoint_ids" {
  description = "Map of Interface Endpoint IDs."

  value = {
    for name, endpoint in aws_vpc_endpoint.interface :
    name => endpoint.id
  }
}

