#############################################
# ECS TASK EXECUTION ROLE
#############################################

resource "aws_iam_role_policy_attachment" "task_execution_managed" {

  role = aws_iam_role.task_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role_policy_attachment" "task_execution_secrets_access" {

  role = aws_iam_role.task_execution.name

  policy_arn = aws_iam_policy.task_execution_secrets_access.arn
}
