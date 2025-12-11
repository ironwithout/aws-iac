terraform {
  backend "s3" {
    # bucket, region, and key are provided via -backend-config flag during init
    # See environments/{env}/backend.hcl for environment-specific configuration
    use_lockfile = true
  }
}
