resource "aws_vpc" "eks_demo" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eks_demo"
  }
}