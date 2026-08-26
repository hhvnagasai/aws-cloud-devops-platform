#############################################
# ECS TASK EXECUTION ROLE
#############################################

output "task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role."
  value       = aws_iam_role.task_execution.arn
}

output "task_execution_role_name" {
  description = "Name of the ECS task execution IAM role."
  value       = aws_iam_role.task_execution.name
}


#############################################
# ECS TASK ROLE
#############################################

output "task_role_arn" {
  description = "ARN of the ECS task IAM role."
  value       = aws_iam_role.task.arn
}

output "task_role_name" {
  description = "Name of the ECS task IAM role."
  value       = aws_iam_role.task.name
}
