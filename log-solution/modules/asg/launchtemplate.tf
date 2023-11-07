resource "aws_launch_template" "cloud_infra_lt" {
  name_prefix   = "asg-cloud-infra-${terraform.workspace}-"
  image_id      = var.ami
  instance_type = var.instance_type
  user_data = filebase64("${var.userdata_filepath}")  
  key_name                = var.ssh_key_name
  disable_api_termination = true
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = "1"
  }

  iam_instance_profile {
    name = var.instance_profile
  }

  block_device_mappings {
    device_name = "xvdb"
    ebs {
      volume_size = 30
    }
  }
    network_interfaces {
    associate_public_ip_address = var.public_ip
    security_groups = var.security_groups
  }

  tags = {
    Name        = "lt-cloud-infra-${terraform.workspace}"
    Project     = "cloud-infra assignment"
    Environment = terraform.workspace
    ManagedBy   = "terraform"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "ec2-cloud-infra-${terraform.workspace}"
      Project     = "cloud-infra assignment"
      Environment = terraform.workspace
      ManagedBy   = "terraform"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name        = "vol-cloud-infra-${terraform.workspace}"
      Project     = "cloud-infra assignment"
      Environment = terraform.workspace
      ManagedBy   = "terraform"
    }
  }
}