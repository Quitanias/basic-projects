# Create Resource Instance 
resource "aws_instance" "example" {
  ami           = "amzn-linux-2023"
  instance_type = "c6a.2xlarge"

  cpu_options {
    core_count       = 2
    threads_per_core = 2
  }

  ebs_block_device {
    volume_id   = aws_ebs_volume.example.id
    device_name = "/dev/sdh"
  }

  tags       = local.tags
  depends_on = [aws_ebs_volume.example]
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-2a"
  size              = 40
  encrypted         = true
  iops              = "3000"
  type              = "gp3"

  tags = local.tags
}
