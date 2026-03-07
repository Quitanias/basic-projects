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

// Create (or ensure) a KV secrets engine mount using version 2.
resource "vault_mount" "kv_v2" {
  path    = "secret"
  type    = "kv"
  options = { version = "2" }
}

// Store the generated password in the KV v2 secret store.
resource "vault_kv_secret_v2" "generated_password" {
  mount               = vault_mount.kv_v2.path
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
  mount    = vault_mount.kv_v2.path
  name     = vault_kv_secret_v2.generated_password.name
}

data "vault_kv_secret_v2" "username" {
  mount    = vault_mount.kv_v2.path
  name     = "username"
}
