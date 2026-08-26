output "nat_gateway_ids" {

  description = "IDs of NAT Gateways."

  value = [
    for nat in aws_nat_gateway.this :
    nat.id
  ]

}



output "nat_gateway_public_ips" {

  description = "Public IPs of NAT Gateways."

  value = [
    for nat in aws_nat_gateway.this :
    nat.public_ip
  ]

}



output "elastic_ip_ids" {

  description = "Elastic IP IDs."

  value = [
    for eip in aws_eip.this :
    eip.id
  ]

}
