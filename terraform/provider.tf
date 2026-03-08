terraform {
  required_version = "~> 1.14.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
  }
}

provider "local" {}

# AWS provider configured to point at LocalStack (default endpoint http://localhost:4566)
provider "aws" {
  region                      = var.region
  access_key                  = ephemeral.vault_kv_secret_v2.aws_credentials.data["access_key"]
  secret_key                  = ephemeral.vault_kv_secret_v2.aws_credentials.data["secret_key"]
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  s3_use_path_style           = true 

  endpoints {
    s3  = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
    rds = "http://localhost:4566"
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
}
