# Basic Terraform Project

This repository contains a minimal Terraform configuration for local testing.

Local testing uses LocalStack to simulate AWS services.

Quick start

1. Start LocalStack (Docker):

```bash
docker run --rm -it -p 4566:4566 localstack/localstack
```

2. Change to the Terraform directory and initialize:

```bash
cd basic-projects/terraform
terraform init -backend=false
```

3. Validate configuration:

```bash
terraform validate
```

4. Create a plan (use `dev.tfvars` or rename it to `terraform.tfvars`):

```bash
terraform plan -var-file=dev.tfvars
```

Notes

- If you plan to use LocalStack, start it before running `terraform plan`.
- You can export variables as environment variables (e.g., `TF_VAR_region`) instead of using a tfvars file.
- Use `-refresh=false` to skip refreshing remote state during `plan` when testing locally.