resource "aws_instance" "cloud_infra_ec2" {
  ami           = var.instance_ami
  instance_type = var.instance_size
  subnet_id     = var.subnet_id
  root_block_device {
    volume_size = var.instance_root_device_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name      = "ec2-${terraform.workspace}"
    ManagedBy = "terraform"
  }
}

resource "aws_eip" "eip" {
  count  = var.create_eip ? 1 : 0
  domain = "vpc"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "cloud-infra-${terraform.workspace}-ec2"
    Project     = "cloud-infra assignment"
    Environment = "${terraform.workspace}"
    ManagedBy   = "terraform"
  }
}

resource "aws_eip_association" "eip_assoc" {
  count         = (var.create_eip) ? 1 : 0
  instance_id   = aws_instance.cloud_infra_ec2.id
  allocation_id = aws_eip.eip[0].id
}