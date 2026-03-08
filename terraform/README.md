## Technical summary

This is a small demonstrative Terraform project intended to simulate an AWS environment locally for testing and review purposes. The local environment is composed of:

- LocalStack (Docker) to emulate AWS services such as S3, EC2 and RDS.
- HashiCorp Vault (dev mode) to store and expose secrets consumed by the Terraform configuration.
- A bootstrap script `../scripts/setup.sh` that starts Vault and LocalStack and injects the necessary secrets (for example `db_username`, `db_password`, `access_key`, `secret_key`).

Architecture and runtime flow

- Run the bootstrap script to start Vault (listening on port `8200`) and LocalStack (listening on port `4566`) and to populate secrets under `secret/*` in Vault.
- The Terraform configuration in this directory uses the Vault provider to read `secret/username` and a generated secret in `secret/vault`, then passes those values into a local RDS module (`source = "../modules"`).
- The configuration uses a generated password written to a KV v2 path and an ephemeral reference to avoid exposing credentials directly in the root module's plaintext configuration.

Reproduce locally

1. Run the bootstrap script to start Vault and LocalStack and populate secrets:

```bash
cd basic-projects/terraform
bash scripts/setup.sh
```

2. Initialize and validate Terraform:

```bash
terraform init
terraform validate
```

3. Create a plan (example):

```bash
terraform plan -var-file=dev.tfvars
```

Notes and best practices

- Ensure `VAULT_ADDR` and the Vault root token are exported in the same shell where you run `terraform` so Vault data sources can authenticate and read secrets.
- I renamed several resources in the configuration to more descriptive identifiers (for example `app_server`, `data_volume`, `rds_instance`) to improve readability and simplify state review.
- If you need to preserve existing state after renaming resources, use `terraform state mv` to map old resource addresses to the new ones before applying, which avoids recreation or destruction of resources.

Thank you for reviewing this project. The local simulation pattern, Vault integration for secrets, and modular Terraform layout are intended to make technical evaluation straightforward.
