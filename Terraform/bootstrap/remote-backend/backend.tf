terraform {
  backend "s3" {
    bucket         = "hari-pdp-terraform-state-bucket"
    key            = "bootstrap/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "hari-pdp-terraform-state-lock"
    encrypt        = true
  }
}
