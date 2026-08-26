resource "aws_eip" "this" {

  for_each = {
    for nat in var.nat_gateways :
    nat.name => nat
  }

  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${each.value.name}-eip"
    }
  )

}



resource "aws_nat_gateway" "this" {

  for_each = {
    for nat in var.nat_gateways :
    nat.name => nat
  }

  allocation_id = aws_eip.this[each.key].id
  subnet_id     = each.value.subnet_id

  tags = merge(
    var.common_tags,
    {
      Name = each.value.name
    }
  )

}
