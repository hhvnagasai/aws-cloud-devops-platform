#############################################
# Amazon ECR Repository
#############################################

resource "aws_ecr_repository" "this" {

  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.repository_name
    }
  )
}
#############################################
# Amazon ECR Lifecycle Policy
#############################################

resource "aws_ecr_lifecycle_policy" "this" {

  repository = aws_ecr_repository.this.name

  policy = jsonencode({

    rules = [

      {

        rulePriority = 1

        description = "Keep only the latest images"

        selection = {

          tagStatus = "any"

          countType = "imageCountMoreThan"

          countNumber = var.lifecycle_max_image_count
        }

        action = {

          type = "expire"
        }
      }
    ]
  })
}

