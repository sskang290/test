#### Private subnets across 3 AZs
resource "aws_subnet" "cloud_infra_private_subnets_0" {
  for_each          = local.env.subnets.private
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = each.value.cidr.az0
  vpc_id            = aws_vpc.cloud_infra_vpc.id
  tags = merge(
    {
      "Name" = "${each.key}-subnet",
    },
    try(each.value.tags, {})
  )
}
resource "aws_subnet" "cloud_infra_private_subnets_1" {
  for_each          = local.env.subnets.private
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = each.value.cidr.az1
  vpc_id            = aws_vpc.cloud_infra_vpc.id
  tags = merge(
    {
      "Name" = "${each.key}-subnet",
    },
    try(each.value.tags, {})
  )
}
resource "aws_subnet" "cloud_infra_private_subnets_2" {
  for_each          = local.env.subnets.private
  availability_zone = data.aws_availability_zones.available.names[2]
  cidr_block        = each.value.cidr.az2
  vpc_id            = aws_vpc.cloud_infra_vpc.id
  tags = merge(
    {
      "Name" = "${each.key}-subnet",
    },
    try(each.value.tags, {})
  )
}


####  Pubic subnets across 3 AZs
resource "aws_subnet" "cloud_infra_public_subnets_0" {
  for_each          = local.env.subnets.public
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = each.value.cidr.az0
  vpc_id            = aws_vpc.cloud_infra_vpc.id
  tags = merge(
    {
      "Name" = "${each.key}-subnet",
    },
    try(each.value.tags, {})
  )
}
resource "aws_subnet" "cloud_infra_public_subnets_1" {
  for_each          = local.env.subnets.public
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = each.value.cidr.az1
  vpc_id            = aws_vpc.cloud_infra_vpc.id
  tags = merge(
    {
      "Name" = "${each.key}-subnet",
    },
    try(each.value.tags, {})
  )
}
resource "aws_subnet" "cloud_infra_public_subnets_2" {
  for_each          = local.env.subnets.public
  availability_zone = data.aws_availability_zones.available.names[2]
  cidr_block        = each.value.cidr.az2
  vpc_id            = aws_vpc.cloud_infra_vpc.id
  tags = merge(
    {
      "Name" = "${each.key}-subnet",
    },
    try(each.value.tags, {})
  )
}