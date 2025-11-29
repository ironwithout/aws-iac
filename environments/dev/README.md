# Development Environment

This directory contains environment-specific configuration for the **development** environment.

## Setup

1. Copy the example file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your specific values (project name, region, etc.)

3. Initialize and apply:
   ```bash
   cd ../..  # Return to root
   terraform init
   terraform plan -var-file=environments/dev/terraform.tfvars
   terraform apply -var-file=environments/dev/terraform.tfvars
   ```

## Configuration Notes

- **Cost Optimization**: Dev uses Fargate Spot, shorter log retention, minimal replicas
- **Networking**: Uses public subnets with auto-assign public IP (no NAT Gateway)
- **Secrets**: Store in SSM Parameter Store, reference in task definitions

## Important

⚠️ Never commit `terraform.tfvars` - it's gitignored and may contain sensitive values.
