#############################################
# ECS TASK EXECUTION ROLE - CUSTOM POLICY
#############################################

resource "aws_iam_policy" "task_execution_secrets_access" {

  name = "${var.execution_role_name}-secrets-access"

  description = "Allows ECS tasks to retrieve the required Secrets Manager secrets and decrypt them using the project KMS key."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "ReadRequiredSecrets"
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.secrets_arns
      },

      {
        Sid    = "DecryptSecrets"
        Effect = "Allow"

        Action = [
          "kms:Decrypt"
        ]

        Resource = var.kms_key_arn
      }
    ]
  })

  tags = var.common_tags
}
