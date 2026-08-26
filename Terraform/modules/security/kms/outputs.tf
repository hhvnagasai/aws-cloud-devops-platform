output "key_id" {
  description = "The ID of the KMS Key."
  value       = aws_kms_key.this.key_id
}

output "key_arn" {
  description = "The ARN of the KMS Key."
  value       = aws_kms_key.this.arn
}

output "alias_name" {
  description = "The name of the KMS Alias."
  value       = aws_kms_alias.this.name
}

output "alias_arn" {
  description = "The ARN of the KMS Alias."
  value       = aws_kms_alias.this.arn
}
