# AWS data
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

##VPC details
data "aws_vpc" "cloud_infra_vpc" {
  filter {
    name   = "tag:Name"
    values = ["cloud-infra-vpc-${terraform.workspace}"]
  }
}

####SUBNET details
data "aws_subnets" "ec2_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cloud_infra_vpc.id]
  }

  tags = {
    Name = "nat-subnet"
  }
}

data "aws_subnet" "ec2_subnet" {
  for_each = toset(data.aws_subnets.ec2_subnets.ids)

  id = each.value
}

data "aws_subnets" "db_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cloud_infra_vpc.id]
  }

  tags = {
    Name = "db-subnet"
  }
}

data "aws_subnet" "db_subnet" {
  for_each = toset(data.aws_subnets.db_subnets.ids)

  id = each.value
}

data "aws_subnets" "elb_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cloud_infra_vpc.id]
  }

  tags = {
    Name = "elb-subnet"
  }
}

##RDS password
data "aws_secretsmanager_secret_version" "app1_rds_secret" {
  secret_id = "app1_rds_secret"
}

## SSH key pair
data "aws_key_pair" "cloud_infra" {
  key_name           = "cl-infra"
  include_public_key = true
}