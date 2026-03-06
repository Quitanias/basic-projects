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


Module source note

- The `module` block in `main.tf` uses a local path as `source = "../modules"`. Terraform does not "download" local modules into your working directory; it references the folder in place. This is convenient for local development and testing.
- If you want to version and maintain the module in a separate repository, you can keep it as an independent Git repository and add it to this project as a Git submodule. Example:

```bash
# add the module repo as a submodule in ./modules
git submodule add <module-repo-url> modules
git submodule update --init --recursive
```

- Alternatively, reference a remote module directly in the `source` (git URL or registry) so Terraform fetches it during `init`.