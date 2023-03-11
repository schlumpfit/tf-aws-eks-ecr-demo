resource "aws_iam_role" "eks_demo1" {
  name = "eks_demo1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_demo1_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_demo1.name
}

resource "aws_eks_cluster" "eks_demo1" {
  name     = "eks_demo1"
  role_arn = aws_iam_role.eks_demo1.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_demo_eu_central_1a_private.id,
      aws_subnet.eks_demo_eu_central_1b_private.id,
      aws_subnet.eks_demo_eu_central_1a_public.id,
      aws_subnet.eks_demo_eu_central_1b_public.id
    ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_demo1_AmazonEKSClusterPolicy
  ]
}