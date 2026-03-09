#!/bin/bash

# Prevent the script from destroying innocent containers in the user's Docker (before it wiped all Docker containers!)
echo "Cleaning up previous components..."
killall vault 2>/dev/null || true
sudo docker rm -f localstack 2>/dev/null || true

echo "Starting Vault..."
vault server -dev > vault.log 2>&1 &

# Wait for Vault to finish writing the Root Token, preventing race conditions from fixed "sleep 5"
echo "Waiting for Vault..."
while ! grep -qa "Root Token" vault.log; do
  sleep 1
done

export VAULT_ADDR='http://127.0.0.1:8200'
ROOT_TOKEN=$(grep -a "Root Token" vault.log | awk '{print $3}')
export VAULT_TOKEN=$ROOT_TOKEN

# Log in quietly so it doesn't spam the terminal unnecessarily
vault login $VAULT_TOKEN > /dev/null

echo "Creating secrets..."

vault kv put secret/vault \
db_password="123456"

vault kv put secret/aws_credentials \
access_key="AKIA123" \
secret_key="abc123"

vault kv put secret/username \
db_username="admin"

echo "Starting LocalStack..."
# Start the container named 'localstack', allowing it to be easily restarted and killed
sudo docker run -d \
  --name localstack \
  -p 4566:4566 \
  -e SERVICES=s3,ec2,iam,sts \
  localstack/localstack

echo "Waiting for LocalStack edge router to be available..."
# Dynamically test LocalStack until the curl request is successful
while ! curl -s http://localhost:4566 > /dev/null; do
  sleep 2
done

echo "Installing Test Dependencies (Molecule & Terratest)..."
if command -v python3 &> /dev/null; then
  python3 -m venv "ansible/.venv"
  "ansible/.venv/bin/pip" install -r "ansible/requirements.txt" > /dev/null 2>&1 || echo "Warning: Failed to install Ansible test dependencies."
else
  echo "Warning: python3 is not installed. Skipping Molecule dependency installation."
fi

if command -v go &> /dev/null; then
  (cd "test" && go mod tidy > /dev/null 2>&1) || echo "Warning: Failed to download Terratest modules."
else
  echo "Warning: go is not installed. Skipping Terratest dependency download."
fi

echo ""
echo "Environment configured properly!"
echo "Remember to run this script as 'source ../scripts/bootstrap.sh' (or 'source scripts/bootstrap.sh' from root) to preserve VAULT_TOKEN!"
