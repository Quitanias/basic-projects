#!/bin/bash

echo "Starting Vault..."

vault server -dev > vault.log 2>&1 &

sleep 5

export VAULT_ADDR='http://127.0.0.1:8200'

ROOT_TOKEN=$(grep "Root Token" vault.log | awk '{print $3}')

vault login $ROOT_TOKEN

echo "Creating secrets..."

vault kv put secret/vault \
db_password="123456" \
access_key="AKIA123" \
secret_key="abc123"

vault kv put secret/username \
db_username="admin"

echo "Starting LocalStack..."

sudo docker run -d \
-p 4566:4566 \
-e SERVICES=s3,ec2,iam,sts \
localstack/localstack
