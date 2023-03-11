data "tls_certificate" "eks_demo1" {
  url = aws_eks_cluster.eks_demo1.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_demo1" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_demo1.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_demo1.identity[0].oidc[0].issuer
}