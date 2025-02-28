resource "aws_subnet" "private_subnet_2a" {
  vpc_id     = aws_vpc.cluster_vpc.id
  cidr_block = "10.10.16.0/20"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name                                        = "DPD-PRD-VPC-PRV-EKS-2A",
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"           = "1"
    "karpenter.sh/discover"                     = "dpd-eks"
  }
}

resource "aws_subnet" "private_subnet_2c" {
  vpc_id     = aws_vpc.cluster_vpc.id
  cidr_block = "10.10.32.0/20"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name                                        = "DPD-PRD-VPC-PRV-EKS-2C",
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"           = "1"
    "karpenter.sh/discover"                     = "dpd-eks"
  }
}

resource "aws_route_table_association" "private2a" {
  subnet_id      = aws_subnet.private_subnet_2a.id
  route_table_id = aws_route_table.nat.id
}


resource "aws_route_table_association" "private2c" {
  subnet_id      = aws_subnet.private_subnet_2c.id
  route_table_id = aws_route_table.nat.id
}
