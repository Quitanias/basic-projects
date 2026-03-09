.PHONY: help bootstrap init plan apply destroy test-ansible test-tf clean

help:
	@echo "Available commands:"
	@echo "  make bootstrap   - Starts LocalStack, Vault, and loads secrets into Vault."
	@echo "                     Note: You still MUST run 'source scripts/bootstrap.sh' directly"
	@echo "                     in your terminal to export VAULT_TOKEN to your current shell."
	@echo "  make init        - Initializes Terraform (downloads providers/modules)."
	@echo "  make plan        - Generates the Terraform execution plan."
	@echo "  make apply       - Applies the Terraform plan (auto-approves)."
	@echo "  make destroy     - Destroys the Terraform infrastructure (auto-approves)."
	@echo "  make test-ansible- Runs Molecule tests for the Ansible roles/playbooks."
	@echo "  make test-tf     - Runs Terratest (Go) to validate Terraform."
	@echo "  make clean       - Cleans up Terraform state files, Docker containers, and logs."

bootstrap:
	@echo "Starting Bootstrap Script..."
	@bash scripts/bootstrap.sh
	@echo "\n--- IMPORTANT ---"
	@echo "To allow Terraform to read the Vault secrets, you MUST run this command in your terminal now:"
	@echo "source scripts/bootstrap.sh"

init:
	@echo "Initializing Terraform..."
	@cd terraform && terraform init

plan:
	@echo "Planning Terraform..."
	@cd terraform && terraform plan -var-file=dev.tfvars

apply:
	@echo "Applying Terraform..."
	@cd terraform && terraform apply -var-file=dev.tfvars -auto-approve

destroy:
	@echo "Destroying Terraform Infrastructure..."
	@cd terraform && terraform destroy -var-file=dev.tfvars -auto-approve

test-ansible:
	@echo "Running Ansible Tests (Molecule)..."
	@cd ansible && .venv/bin/ansible-galaxy collection install ansible.posix -p collections --force > /dev/null 2>&1 || true
	@cd ansible && sudo .venv/bin/molecule test

test-tf:
	@echo "Running Terraform Tests (Terratest)..."
	@export VAULT_ADDR="http://127.0.0.1:8200" && export VAULT_TOKEN=$$(awk '/Root Token/ {print $$3; exit}' vault.log) && \
	cd test && go test -v -timeout 30m

clean:
	@echo "Cleaning up local environment..."
	@sudo docker rm -f localstack 2>/dev/null || true
	@killall vault 2>/dev/null || true
	@rm -rf vault.log
	@rm -rf terraform/.terraform terraform/.terraform.lock.hcl terraform/terraform.tfstate terraform/terraform.tfstate.backup
	@echo "Environment cleaned."
