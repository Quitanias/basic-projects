terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

# AWS provider configured to point at LocalStack (default endpoint http://localhost:4566)
provider "aws" {
  region                      = var.region
  access_key                  = var.access_key
  secret_key                  = var.secret_key
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3  = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}

# Simple S3 bucket to test AWS provider against LocalStack
resource "aws_s3_bucket" "test_bucket" {
  bucket = "tf-localstack-test-bucket"
}
