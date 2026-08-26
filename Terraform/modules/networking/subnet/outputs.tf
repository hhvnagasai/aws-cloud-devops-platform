output "public_subnet_ids" {
  description = "IDs of all public subnets."

  value = [
    for subnet in aws_subnet.public :
    subnet.id
  ]
}


output "private_subnet_ids" {
  description = "IDs of all private subnets."

  value = [
    for subnet in aws_subnet.private :
    subnet.id
  ]
}


output "public_subnet_arns" {
  description = "ARNs of all public subnets."

  value = [
    for subnet in aws_subnet.public :
    subnet.arn
  ]
}


output "private_subnet_arns" {
  description = "ARNs of all private subnets."

  value = [
    for subnet in aws_subnet.private :
    subnet.arn
  ]
}
