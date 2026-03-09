# outputs.tf

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.app_server.private_ip
}

output "ebs_volume_id" {
  description = "The ID of the attached EBS Volume"
  value       = aws_ebs_volume.data_volume.id
}
