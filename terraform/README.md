# Basic Terraform Project

This repository contains a minimal Terraform configuration for local testing.

Local testing uses LocalStack to simulate AWS services.

Quick start

1. Run the project setup script (starts LocalStack, vault and prepares environment):

```bash
bash scripts/setup.sh
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


## Resumo técnico

Projeto demonstrativo em Terraform para simular uma infraestrutura AWS localmente. O ambiente é composto por:

- LocalStack (via Docker) para emular serviços AWS (S3, EC2, RDS, etc.).
- HashiCorp Vault (modo `dev`) para armazenar e expor secrets usados pela configuração.
- Script de bootstrap `../scripts/setup.sh` que inicializa o Vault, popula secrets (ex.: `db_username`, `db_password`, `access_key`, `secret_key`) e sobe o LocalStack.

Arquitetura e fluxo operacional:

- Executar `../scripts/setup.sh` inicializa o Vault (porta `8200`) e o LocalStack (porta `4566`) e grava secrets em `secret/*` no Vault.
- O Terraform (neste diretório) usa o provider Vault para ler `secret/username` e um secret gerado em `secret/vault` e então passa esses valores para o módulo RDS local (`source = "../modules"`).
- O uso de um secret engine KV v2 + uma senha gerada evita expor credenciais em texto claro no estado do root; a configuração emprega blocos `ephemeral` e `vault_kv_secret_v2` para gerar/gravar/ler a senha.

Reproduzir localmente (sintético):

1. No repositório, execute o bootstrap:

```bash
bash ../scripts/setup.sh
```

2. Entre na pasta Terraform e inicialize:

```bash
cd basic-projects/terraform
terraform init
terraform validate
```

3. Gerar um plano (exemplo):

```bash
terraform plan -var-file=dev.dev.tfvars
```

Observações técnicas e boas práticas:

- O script `../scripts/setup.sh` inicia o Vault em modo `dev` e injeta os secrets necessários; para que o Terraform leia os secrets via data sources, `VAULT_ADDR` e o token de root devem estar acessíveis no ambiente onde o `terraform` é executado.
- Renomeei recursos no código para nomes descritivos (ex.: `app_server`, `data_volume`, `rds_instance`) para facilitar triagem de estado e revisão por pares.
- Se você pretende preservar o estado existente após renomear recursos, use `terraform state mv` para mapear endereços antigos para os novos e evitar recriação/destruição indesejada.

Obrigado por revisar este projeto — espero que o padrão de simulação local, uso de Vault para secrets e o layout modular do Terraform tornem a análise direta e técnica.

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
bash ../scripts/setup.sh
```

2. Initialize and validate Terraform:

```bash
cd basic-projects/terraform
terraform init
terraform validate
```

3. Create a plan (example):

```bash
terraform plan -var-file=dev.dev.tfvars
```

Notes and best practices

- Ensure `VAULT_ADDR` and the Vault root token are exported in the same shell where you run `terraform` so Vault data sources can authenticate and read secrets.
- I renamed several resources in the configuration to more descriptive identifiers (for example `app_server`, `data_volume`, `rds_instance`) to improve readability and simplify state review.
- If you need to preserve existing state after renaming resources, use `terraform state mv` to map old resource addresses to the new ones before applying, which avoids recreation or destruction of resources.

Thank you for reviewing this project. The local simulation pattern, Vault integration for secrets, and modular Terraform layout are intended to make technical evaluation straightforward.
