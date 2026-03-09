# Create Resource Instance 
resource "aws_instance" "app_server" {
  ami           = var.ami
  instance_type = var.instance_type

  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook -i ${self.private_ip}, playbooks/app.yml"
  }

  tags = local.tags
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.data_volume.id
  instance_id = aws_instance.app_server.id
}

resource "aws_ebs_volume" "data_volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  encrypted         = true
  iops              = "3000"
  type              = var.volume_type

  tags = local.tags
}

# Use module to create RDS instance (Requires LocalStack PRO)
# module "rds_instance" {
#   source              = "../modules"
#   db_name             = var.db_name
#   db_username         = data.vault_kv_secret_v2.username.data["db_username"]
#   password_wo         = tostring(ephemeral.vault_kv_secret_v2.vault_ref.data["password"])
#   password_wo_version = vault_kv_secret_v2.generated_password.data_json_wo_version
# }

# Start the Ansible playbook to install Nginx on the EC2 instance
resource "local_file" "ansible_inventory" {
  content = <<EOT
[web]
${aws_instance.app_server.private_ip} ansible_user=ec2-user
EOT

  filename = "../ansible/inventory/hosts"

  depends_on = [aws_instance.app_server]
}
