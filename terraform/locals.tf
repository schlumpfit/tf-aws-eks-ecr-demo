locals {
  aws_ecr_url          = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
  flask_demo_image_url = "${aws_ecr_repository.eks_demo.repository_url}:0.1.0"
}