data "aws_iam_policy_document" "eks_demo_ecs_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_demo1.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:eks_demo_ecs_pull"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_demo1.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_demo_ecr_oidc" {
  assume_role_policy = data.aws_iam_policy_document.eks_demo_ecs_oidc_assume_role_policy.json
  name               = "eks-demo-ecr-oidc"
}

resource "aws_iam_policy" "eks_demo_ecr_allowPull" {
  name = "eks_demo_ecr_oidc"
  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability"
      ]
      Resource = "arn:aws:ecr:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_demo_ecr_allowPull" {
  role       = aws_iam_role.eks_demo_ecr_oidc.name
  policy_arn = aws_iam_policy.eks_demo_ecr_allowPull.arn
}

output "eks_demo_ecr_policy_arn" {
  value = aws_iam_role.eks_demo_ecr_oidc
}