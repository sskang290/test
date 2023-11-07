resource "aws_internet_gateway" "cloud_infra_igw" {
  vpc_id = aws_vpc.cloud_infra_vpc.id

  tags = {
    Name = "cloud-infra-gw"
  }
}

#resource "aws_nat_gateway" "cloud_infra_nat_gw {
#  for e
#  allocation_id = aws_eip.nat_eip.id
#  subnet_id     = aws_subnet.nat-subnet.id
#
#  tags = {
#    Name = "gw NAT"
#  }
#
# #  depends_on = [aws_internet_gateway.example]
#}