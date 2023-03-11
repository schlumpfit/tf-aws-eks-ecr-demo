resource "aws_internet_gateway" "eks_demo_public" {
  vpc_id = aws_vpc.eks_demo.id

  tags = {
    Name = "eks_demo_public"
    Zone = "Public"
  }
}