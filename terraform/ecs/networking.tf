resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name  = "Siddiqi ARM VPC",
    owner = "Zafar Siddiqi",
    team  = "Siddiqi Marketing"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "pub_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name  = "subnet-east1-a",
    team  = "Siddiqi Marketing",
    owner = "Zafar Siddiqi",
  }
}

resource "aws_subnet" "pub_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name  = "subnet-east1-b",
    team  = "Siddiqi Marketing",
    owner = "Zafar Siddiqi"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    team  = "Siddiqi Marketing",
    owner = "Zafar Siddiqi"
  }
}

# Create route table association for subnet_a
resource "aws_route_table_association" "route_table_association_subA" {
  subnet_id      = aws_subnet.pub_subnet_a.id
  route_table_id = aws_route_table.public.id
}

# Create route table association for subnet_b
resource "aws_route_table_association" "route_table_association_subB" {
  subnet_id      = aws_subnet.pub_subnet_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "aws-devsecops-demo-22" {
  description = "Port 22 Admin"
  vpc_id      = aws_vpc.vpc.id
  name_prefix = "aws-devsecops-demo-22-SSH-"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "aws-devsecops-demo-22-SSH",
    team  = "Siddiqi Marketing",
    owner = "Zafar Siddiqi"
  }
}

resource "aws_security_group" "aws-devsecops-demo-ELB" {
  description = "Port 443 Elastic Load Balancer"
  name_prefix = "aws-devsecops-demo-443-ELB-"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags = {
    Name  = "aws-devsecops-demo-443-ELB",
    team  = "Siddiqi Marketing",
    owner = "Zafar Siddiqi"
  }
}

resource "aws_security_group" "aws-devsecops-demo-ELB-HTTP80" {
  description = "Port 80 Elastic Load Balancer"
  name_prefix = "aws-devsecops-demo-ELB-80-"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags = {
    Name = "aws-devsecops-demo-ELB-80"
  }
}

resource "aws_security_group" "aws-devsecops-demo-80" {
  description = "Port 80 internal dev group "
  vpc_id      = aws_vpc.vpc.id
  name_prefix = "aws-devsecops-demo-80-internal-"

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    security_groups = [
      aws_security_group.aws-devsecops-demo-ELB-HTTP80.id,
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags = {
    Name = "aws-devsecops-demo-80-internal"
  }
}
