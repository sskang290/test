output "ec2_id" {
  value = aws_instance.cloud_infra_ec2.id
}

output "ec2_ip" {
  value = aws_instance.cloud_infra_ec2.private_ip
}

