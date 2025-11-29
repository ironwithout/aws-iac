# GitHub Actions CI/CD Setup

## Overview

This repository uses GitHub Actions for automated Terraform validation, linting, and planning on every pull request to `main`.

## Workflows

### `terraform-validate.yml`
**Triggers**: Pull requests and pushes to `main`

**Steps**:
1. ✅ **Format Check** - Ensures code follows Terraform style
2. ⚙️ **Init** - Initializes Terraform (without backend)
3. 🤖 **Validate** - Checks configuration syntax and consistency
4. 🔍 **TFLint** - Runs AWS-specific linting rules
5. 📖 **Plan** - Generates execution plan (no AWS credentials needed!)
6. 💬 **PR Comment** - Posts results with plan output as PR comment
7. 📊 **Summary** - Creates job summary

**Note**: `terraform plan` runs **without AWS credentials** because we have no `data` sources that query AWS APIs. Plan calculates changes based purely on code.

## Required Secrets

**None currently required!** 🎉

The CI workflow runs `terraform plan` **without AWS credentials** because:
- ✅ No `data` sources that query AWS APIs
- ✅ Plan calculates changes based on code only
- ✅ No state refresh (using `-backend=false` on init)

### When You'll Need AWS Credentials

If you add `data` sources that query AWS (e.g., `data "aws_ami"`, `data "aws_vpc"`), you'll need to:

1. Add secrets to GitHub:
   ```bash
   AWS_ACCESS_KEY_ID: AKIA...
   AWS_SECRET_ACCESS_KEY: <secret-key>
   ```

2. Add the AWS credentials configuration step before plan in the workflow

## Local Testing

Run the same checks locally before pushing:

```bash
# Format check
terraform fmt -check -recursive

# Initialize
terraform init

# Validate
terraform validate

# TFLint (install first: https://github.com/terraform-linters/tflint)
tflint --init
tflint --recursive

# Plan
terraform plan -var-file=environments/dev/terraform.tfvars
```

## TFLint Configuration

The `.tflint.hcl` file configures:
- AWS-specific rules (resource naming, deprecated features)
- Variable and output documentation requirements
- Unused declaration detection
- Type checking

## Workflow Permissions

The workflow requires:
- `contents: read` - Read repository code
- `pull-requests: write` - Comment on PRs
- `id-token: write` - For OIDC (future enhancement)

## Future Enhancements

- [ ] Add Checkov security scanning
- [ ] Add cost estimation with Infracost
- [ ] Switch to OIDC authentication (remove access keys)
- [ ] Add deployment workflow for auto-apply on merge to main
- [ ] Environment-specific workflows (dev/prod)
- [ ] Terraform docs generation

## Troubleshooting

### "No AWS credentials found"
Ensure secrets are set correctly in GitHub repository settings.

### "Plan failed: Unauthorized"
Check that terraform-deployer IAM policy includes required permissions.

### "Format check failed"
Run `terraform fmt -recursive` locally and commit changes.
