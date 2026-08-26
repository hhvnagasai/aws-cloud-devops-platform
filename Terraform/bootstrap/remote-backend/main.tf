module "terraform_state_bucket" {
  source = "../../modules/storage/s3"

  bucket_name = "hari-pdp-terraform-state-bucket"

  common_tags = {
    Environment = "bootstrap"
    Project     = "Production-DevOps-Platform"
    ManagedBy   = "Terraform"
    Owner       = "Hari"
  }
}
module "terraform_state_lock_table" {
  source = "../../modules/database/dynamodb"

  table_name = "hari-pdp-terraform-state-lock"

  common_tags = {
    Environment = "bootstrap"
    Project     = "Production-DevOps-Platform"
    ManagedBy   = "Terraform"
    Owner       = "Hari"
  }
}
