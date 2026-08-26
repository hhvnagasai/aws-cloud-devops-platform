resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = each.value.name
    }
  )
}

locals {
  cidr_ingress_rules = flatten([
    for group_name, group in var.security_groups : [
      for rule_index, rule in group.ingress_rules : [
        for cidr in rule.cidr_blocks : {
          key         = "${group_name}-${rule_index}-${cidr}"
          group_name  = group_name
          description = rule.description
          protocol    = rule.protocol
          from_port   = rule.from_port
          to_port     = rule.to_port
          cidr_ipv4   = cidr
        }
      ]
    ]
  ])

  security_group_ingress_rules = flatten([
    for group_name, group in var.security_groups : [
      for rule_index, rule in group.ingress_rules : {
        key               = "${group_name}-${rule_index}-sg"
        group_name        = group_name
        description       = rule.description
        protocol          = rule.protocol
        from_port         = rule.from_port
        to_port           = rule.to_port
        source_group_name = rule.source_group_name
      }
      if rule.source_group_name != null
    ]
  ])

  egress_rules = flatten([
    for group_name, group in var.security_groups : [
      for rule_index, rule in group.egress_rules : [
        for cidr in rule.cidr_blocks : {
          key         = "${group_name}-${rule_index}-${cidr}"
          group_name  = group_name
          description = rule.description
          protocol    = rule.protocol
          from_port   = rule.from_port
          to_port     = rule.to_port
          cidr_ipv4   = cidr
        }
      ]
    ]
  ])
}

resource "aws_vpc_security_group_ingress_rule" "cidr" {
  for_each = {
    for rule in local.cidr_ingress_rules : rule.key => rule
  }

  security_group_id = aws_security_group.this[each.value.group_name].id

  description = each.value.description
  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_ipv4   = each.value.cidr_ipv4
}

resource "aws_vpc_security_group_ingress_rule" "security_group" {
  for_each = {
    for rule in local.security_group_ingress_rules : rule.key => rule
  }

  security_group_id = aws_security_group.this[each.value.group_name].id

  description = each.value.description
  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port

  referenced_security_group_id = aws_security_group.this[
    each.value.source_group_name
  ].id
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = {
    for rule in local.egress_rules : rule.key => rule
  }

  security_group_id = aws_security_group.this[each.value.group_name].id

  description = each.value.description
  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_ipv4   = each.value.cidr_ipv4
}
