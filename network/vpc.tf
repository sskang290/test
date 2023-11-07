# VPC creation
resource "aws_vpc" "cloud_infra_vpc" {
  cidr_block           = "10.0.0.0/19"
  enable_dns_hostnames = true
  tags = {
    Name = "cloud-infra-vpc-${terraform.workspace}"
  }
}