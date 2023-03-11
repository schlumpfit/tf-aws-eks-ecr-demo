resource "aws_route_table" "eks_demo_private" {
  vpc_id = aws_vpc.eks_demo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_demo_nat.id
  }

  tags = {
    Name = "eks_demo_private"
  }
}

resource "aws_route_table" "eks_demo_public" {
  vpc_id = aws_vpc.eks_demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_demo_public.id
  }

  tags = {
    Name = "eks_demo_public"
  }
}

resource "aws_route_table_association" "net_0_private" {
  subnet_id      = aws_subnet.eks_demo_eu_central_1a_private.id
  route_table_id = aws_route_table.eks_demo_private.id
}

resource "aws_route_table_association" "net_1_private" {
  subnet_id      = aws_subnet.eks_demo_eu_central_1b_private.id
  route_table_id = aws_route_table.eks_demo_private.id
}

resource "aws_route_table_association" "net_2_public" {
  subnet_id      = aws_subnet.eks_demo_eu_central_1a_public.id
  route_table_id = aws_route_table.eks_demo_public.id
}

resource "aws_route_table_association" "net_3_public" {
  subnet_id      = aws_subnet.eks_demo_eu_central_1b_public.id
  route_table_id = aws_route_table.eks_demo_public.id
}