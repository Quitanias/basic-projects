# Create Resource Instance 
resource "aws_instance" "app_server" {
  ami           = "amzn-linux-2023"
  instance_type = "c6a.2xlarge"

  cpu_options {
    core_count       = 2
    threads_per_core = 2
  }

  ebs_block_device {
    volume_id   = aws_ebs_volume.data_volume.id
    device_name = "/dev/sdh"
  }

  tags       = local.tags
  depends_on = [aws_ebs_volume.data_volume]
}

resource "aws_ebs_volume" "data_volume" {
  availability_zone = "us-east-2a"
  size              = 40
  encrypted         = true
  iops              = "3000"
  type              = "gp3"

  tags = local.tags
}

# Use module to create RDS instance
module "rds_instance" {
  source = "../modules"
  db_name              = var.db_name
  db_username          = data.vault_kv_secret_v2.username.data["db_username"]
  password_wo          = tostring(ephemeral.vault_kv_secret_v2.vault_ref.data["db_password"])
  password_wo_version  = vault_kv_secret_v2.generated_password.data_json_wo_version
}