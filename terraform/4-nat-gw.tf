resource "aws_eip" "eks_demo_nat_ip" {
  vpc = true

  depends_on = [
    aws_internet_gateway.eks_demo_public
  ]

  tags = {
    Name = "eks_demo_nat_ip"
  }
}

resource "aws_nat_gateway" "eks_demo_nat" {
  allocation_id = aws_eip.eks_demo_nat_ip.id
  subnet_id     = aws_subnet.eks_demo_eu_central_1a_public.id

  tags = {
    Name = "eks_demo_nat"
  }

  depends_on = [
    aws_internet_gateway.eks_demo_public
  ]
}