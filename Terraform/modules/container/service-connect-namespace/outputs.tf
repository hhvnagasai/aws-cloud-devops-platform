output "id" {
  description = "ID of the ECS Service Connect namespace."
  value       = aws_service_discovery_http_namespace.this.id
}

output "arn" {
  description = "ARN of the ECS Service Connect namespace."
  value       = aws_service_discovery_http_namespace.this.arn
}

output "name" {
  description = "Name of the ECS Service Connect namespace."
  value       = aws_service_discovery_http_namespace.this.name
}
