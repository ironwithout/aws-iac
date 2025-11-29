# GitHub Actions Setup Checklist

## ✅ Files Created

- `.github/workflows/terraform-validate.yml` - Terraform validation workflow
- `.tflint.hcl` - TFLint configuration
- `.github/README.md` - CI/CD documentation

## 🔐 Setup Steps

### 1. No Secrets Required! ✨

The workflow runs `terraform plan` **without AWS credentials** because:
- ✅ No `data` sources that query AWS APIs
- ✅ Plan generates based on code definitions only
- ✅ Keeps CI simple, fast, and secure

**When you'll need credentials**: If you add `data "aws_*"` resources that query existing AWS infrastructure.

### 2. Push This Branch

```bash
git add .github/ .tflint.hcl
git commit -m "ci: add GitHub Actions workflow for Terraform validation"
git push origin ci/setup-gh-actions
```

### 3. Create Pull Request

```bash
# Via GitHub CLI (if installed)
gh pr create --base main --title "CI: Setup GitHub Actions workflow" --body "Adds automated Terraform validation, linting, and planning for PRs"

# Or manually:
# Go to: https://github.com/ironwithout/aws-iac/compare/main...ci/setup-gh-actions
```

### 4. Verify Workflow Runs

Once PR is created, the workflow will automatically:
- ✅ Check Terraform formatting
- ✅ Validate configuration
- ✅ Run TFLint
- ✅ Generate Terraform plan
- ✅ Comment results with plan output on PR

You can review the plan directly in the PR comment before merging! 🎉

## 🧪 Test Locally First

```bash
# Format check
terraform fmt -check -recursive

# Validate
terraform validate

# Install TFLint (if not already installed)
# macOS: brew install tflint
# Linux: curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Run TFLint
tflint --init
tflint --recursive
```

## 📊 What the Workflow Does

| Step | Purpose | Fails PR? |
|------|---------|-----------|
| Format Check | Ensures consistent code style | ❌ Warning only |
| Init | Downloads providers | ✅ Yes |
| Validate | Checks syntax/logic | ✅ Yes |
| TFLint | AWS-specific rules | ❌ Warning only |
| Plan | Shows infrastructure changes | ✅ Yes |
| PR Comment | Posts results to PR | N/A |

## 🔒 Security Notes

- ✅ **No AWS credentials stored in GitHub** - Safer and simpler!
- ✅ Plan runs without AWS API calls (no `data` sources)
- ✅ All checks are static analysis or code-based
- 💡 If you add `data` sources, you'll need to add AWS credentials to GitHub secrets

## 🎯 Next Steps After Merging

1. All future PRs will automatically run these checks
2. You can require checks to pass before merging (branch protection)
3. Consider adding auto-apply on merge to `main` (future enhancement)
