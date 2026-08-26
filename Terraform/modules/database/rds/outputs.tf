output "db_instance_id" {
  description = "ID of the RDS DB instance."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "ARN of the RDS DB instance."
  value       = aws_db_instance.this.arn
}

output "db_endpoint" {
  description = "DNS endpoint of the RDS DB instance."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port of the RDS DB instance."
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the application database."
  value       = aws_db_instance.this.db_name
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the RDS master user password."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
