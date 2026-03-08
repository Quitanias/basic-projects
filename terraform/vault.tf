// Vault module: store a generated database password in Vault KV v2
//
// This file creates a random password, configures a KV v2 mount in Vault,
// and writes the generated password into that KV path. It also defines an
// ephemeral reference to the stored secret (used by some providers/workflows).

// Generate a random password for the database. The `ephemeral` block here is
// used in this codebase to indicate a short-lived generated value.
ephemeral "random_password" "rds_password" {
  length           = 16
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

// Hardcode the mount path since the "secret" engine already exists on Vault.
// LocalStack relies on this to fetch creds, so it must exist.

// Store the generated password in the KV v2 secret store.
resource "vault_kv_secret_v2" "generated_password" {
  mount               = "secret"
  name                = "vault"
  cas                 = 1
  delete_all_versions = true

  data_json_wo = jsonencode(
    {
      password = ephemeral.random_password.rds_password.result,
    }
  )

  data_json_wo_version = 1
}

// Ephemeral reference to the KV secret resource. Some integrations use an
// ephemeral mapping to read/display connection details without persisting
// them in state; keep this block if your workflow relies on it.
ephemeral "vault_kv_secret_v2" "vault_ref" {
  mount = "secret"
  name  = vault_kv_secret_v2.generated_password.name
}

// Fetch the existing AWS credentials from the Vault KV engine.
// This requires the path `secret/aws_credentials` to exist beforehand.
ephemeral "vault_kv_secret_v2" "aws_credentials" {
  mount = "secret"
  name  = "aws_credentials"
}

data "vault_kv_secret_v2" "username" {
  mount = "secret"
  name  = "username"
}
