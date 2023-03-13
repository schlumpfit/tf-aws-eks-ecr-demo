resource "aws_subnet" "eks_demo_eu_central_1a_private" {
  vpc_id            = aws_vpc.eks_demo.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name                              = "eks_demo_eu_central_1a_private"
    Zone                              = "Private"
    "kubernetes.io/cluster/eks_demo1" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "eks_demo_eu_central_1b_private" {
  vpc_id            = aws_vpc.eks_demo.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name                              = "eks_demo_eu_central_1b_private"
    Zone                              = "Private"
    "kubernetes.io/cluster/eks_demo1" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "eks_demo_eu_central_1a_public" {
  vpc_id                  = aws_vpc.eks_demo.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                              = "eks_demo_eu_central_1a_public"
    Zone                              = "Public"
    "kubernetes.io/cluster/eks_demo1" = "owned"
    "kubernetes.io/role/elb"          = "1"
  }
}

resource "aws_subnet" "eks_demo_eu_central_1b_public" {
  vpc_id                  = aws_vpc.eks_demo.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                              = "eks_demo_eu_central_1b_public"
    Zone                              = "Public"
    "kubernetes.io/cluster/eks_demo1" = "owned"
    "kubernetes.io/role/elb"          = "1"
  }
}