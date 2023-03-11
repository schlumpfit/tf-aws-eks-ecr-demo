resource "aws_iam_role" "eks_demo1_nodes" {
  name = "eks_demo1_nodes"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }]
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_demo1_nodes_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_demo1_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_demo1_nodes_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_demo1_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_demo1_nodes_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_demo1_nodes.name
}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.eks_demo1.name
  node_group_name = "private_nodes"
  node_role_arn   = aws_iam_role.eks_demo1_nodes.arn

  subnet_ids = [
    aws_subnet.eks_demo_eu_central_1a_private.id,
    aws_subnet.eks_demo_eu_central_1b_private.id
  ]

  depends_on = [
    aws_iam_role_policy_attachment.eks_demo1_nodes_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_demo1_nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_demo1_nodes_AmazonEKSWorkerNodePolicy
  ]

  instance_types = ["t3.small"]
  capacity_type  = "SPOT"

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  labels = {
    Zone = "Private"
  }
}