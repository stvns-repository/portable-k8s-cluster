# AWS Backend configuration
terraform {
  backend "s3" {
    # S3 bucket name will be passed via CLI thru backend.hcl
    key    = "aws/foundation/terraform.tfstate"
    region = "us-west-2"
    use_lockfile = true
  }
}