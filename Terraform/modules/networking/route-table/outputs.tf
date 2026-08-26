output "route_table_ids" {

  description = "Route table IDs."

  value = [
    for route_table in aws_route_table.this :
    route_table.id
  ]

}



output "route_table_arns" {

  description = "Route table ARNs."

  value = [
    for route_table in aws_route_table.this :
    route_table.arn
  ]

}
