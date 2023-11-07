####  As of now I have created 2 route tables but we can create route tables for each subnet which will allow us more control
####  over the traffic.

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloud_infra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_infra_igw.id
  }

  tags = {
    Name = "public-rt"
  }
}


resource "aws_route_table" "internal_rt" {
  vpc_id = aws_vpc.cloud_infra_vpc.id

  tags = {
    Name = "internal-rt"
  }
}

#### Route table association for private subnets
resource "aws_route_table_association" "private_rt_az0" {
  for_each       = local.env.subnets.private
  subnet_id      = aws_subnet.cloud_infra_private_subnets_0[each.key].id
  route_table_id = aws_route_table.internal_rt.id
}
resource "aws_route_table_association" "private_rt_az1" {
  for_each       = local.env.subnets.private
  subnet_id      = aws_subnet.cloud_infra_private_subnets_1[each.key].id
  route_table_id = aws_route_table.internal_rt.id
}
resource "aws_route_table_association" "private_rt_az2" {
  for_each       = local.env.subnets.private
  subnet_id      = aws_subnet.cloud_infra_private_subnets_2[each.key].id
  route_table_id = aws_route_table.internal_rt.id
}


#### Route table association for public subnets
resource "aws_route_table_association" "public_rt_az0" {
  for_each       = local.env.subnets.public
  subnet_id      = aws_subnet.cloud_infra_public_subnets_0[each.key].id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_rt_az1" {
  for_each       = local.env.subnets.public
  subnet_id      = aws_subnet.cloud_infra_public_subnets_1[each.key].id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_rt_az2" {
  for_each       = local.env.subnets.public
  subnet_id      = aws_subnet.cloud_infra_public_subnets_2[each.key].id
  route_table_id = aws_route_table.public_rt.id
}