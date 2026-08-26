resource "aws_subnet" "public" {

  for_each = {
    for subnet in var.public_subnets :
    subnet.name => subnet
  }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    var.common_tags,
    {
      Name = each.value.name
    }
  )

}


resource "aws_subnet" "private" {

  for_each = {
    for subnet in var.private_subnets :
    subnet.name => subnet
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    var.common_tags,
    {
      Name = each.value.name
    }
  )

}
