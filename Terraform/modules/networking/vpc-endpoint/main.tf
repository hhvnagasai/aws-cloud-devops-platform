#################################################
# Current AWS Region
#################################################

data "aws_region" "current" {}
#################################################
# Security Group for Interface VPC Endpoints
#################################################

resource "aws_security_group" "vpc_endpoint" {

  count = var.create_security_group ? 1 : 0

  name        = var.security_group_name
  description = "Security Group for Interface VPC Endpoints"
  vpc_id      = var.vpc_id

  ingress {

    description = "Allow HTTPS traffic"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = var.allowed_cidr_blocks

  }

  egress {

    description = "Allow all outbound traffic"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(
    var.tags,
    {
      Name = var.security_group_name
    }
  )

}
#################################################
# Gateway VPC Endpoints
#################################################

resource "aws_vpc_endpoint" "gateway" {

  for_each = toset(var.gateway_endpoints)

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  policy = var.endpoint_policy

  tags = merge(
    var.tags,
    {
      Name = each.value
    }
  )
}
#################################################
# Interface VPC Endpoints
#################################################

resource "aws_vpc_endpoint" "interface" {

  for_each = toset(var.interface_endpoints)

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type = "Interface"

  subnet_ids = var.private_subnet_ids

  security_group_ids = var.create_security_group ? [
    aws_security_group.vpc_endpoint[0].id
    ] : [
    var.security_group_id
  ]

  private_dns_enabled = true

  policy = var.endpoint_policy

  tags = merge(
    var.tags,
    {
      Name = each.value
    }
  )
}
