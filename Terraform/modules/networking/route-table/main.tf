resource "aws_route_table" "this" {

  for_each = {
    for route_table in var.route_tables :
    route_table.name => route_table
  }

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = each.value.name
    }
  )

}



resource "aws_route" "this" {

  for_each = {
    for route in var.routes :
    route.name => route
  }

  route_table_id         = aws_route_table.this[each.value.route_table_name].id
  destination_cidr_block = each.value.destination_cidr_block

  gateway_id     = try(each.value.gateway_id, null)
  nat_gateway_id = try(each.value.nat_gateway_id, null)

}



resource "aws_route_table_association" "this" {

  for_each = {
    for association in var.route_table_associations :
    association.name => association
  }

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.this[each.value.route_table_name].id

}
