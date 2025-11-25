# Backend configuration for Terraform state
# Note: Backend resources (S3 bucket + DynamoDB table) must be bootstrapped manually
# before first `terraform init`.
#
# Uncomment and configure after creating backend resources:
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "aws-iac/ecs-webapp/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     kms_key_id     = "alias/terraform-state"
#     dynamodb_table = "terraform-state-lock"
#   }
# }
