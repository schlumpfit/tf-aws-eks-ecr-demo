resource "aws_vpc" "eks_demo" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true # Default is already true, but make it explcit.
  enable_dns_hostnames = true

  tags = {
    Name = "eks_demo"
  }
}