resource "aws_subnet" "public_subnet_2a" {
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"

  tags = {
    "Name"                                      = "DPD-PRD-VPC-PUB-BST-2A",
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_subnet" "public_subnet_2c" {
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block              = "10.10.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2c"

  tags = {
    "Name"                                      = "DPD-PRD-VPC-PUB-BST-2C",
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_route_table_association" "public_2a" {
  subnet_id      = aws_subnet.public_subnet_2a.id
  route_table_id = aws_route_table.igw_route_table.id
}


resource "aws_route_table_association" "public_2c" {
  subnet_id      = aws_subnet.public_subnet_2c.id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.cluster_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DPD-PRD-VPC-PUB-BST-SG"
  }
}

resource "aws_security_group" "monitoring_sg" {
  vpc_id = aws_vpc.cluster_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 16686
    to_port     = 16686
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DPD-PRD-VPC-PUB-ALB-SG"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
}

resource "aws_eip" "monitoring_eip" {
  instance = aws_instance.monitoring.id
  domain   = "vpc"
}


resource "aws_instance" "bastion" {
  ami                    = "ami-0ebc70f5d762ab467"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet_2a.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name               = "dapanda"

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "DPD-PRD-VPC-PUB-BST-2A"
  }
}

resource "aws_instance" "monitoring" {
  ami                    = "ami-04a65cdbfc1861b31"
  instance_type          = "t3.large"
  subnet_id              = aws_subnet.public_subnet_2c.id
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]
  associate_public_ip_address = true
  key_name               = "dapanda"

  root_block_device {
    volume_size = 100
  }

  tags = {
    Name = "DPD-PRD-VPC-PUB-MON-2C"
  }
}

