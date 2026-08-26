output "security_group_ids" {
  description = "Map of security group names to their AWS security group IDs."
  value = {
    for name, security_group in aws_security_group.this :
    name => security_group.id
  }
}
