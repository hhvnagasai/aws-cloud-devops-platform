output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnet.private_subnet_ids
}

output "igw_id" {
  value = module.igw.igw_id
}

#################################################
# Secrets Manager Outputs
#################################################

output "secret_id" {
  description = "ID of the Secrets Manager secret."
  value       = module.secrets_manager.secret_id
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret."
  value       = module.secrets_manager.secret_arn
}
#################################################
# Amazon ECR Outputs
#################################################

output "ecr_repositories" {
  description = "ECR repository information for application services."

  value = {
    for name, repo in module.ecr : name => {
      repository_name = repo.repository_name
      repository_arn  = repo.repository_arn
      repository_url  = repo.repository_url
    }
  }
}
