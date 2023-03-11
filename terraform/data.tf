data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "eks_demo" {
  registry_id = aws_ecr_repository.eks_demo.registry_id
}

#data "shell_script" "flask_app" {
#  lifecycle_commands {
#    read = <<-EOF
#          echo "{\"version\": \"$(poetry version -s)\"}"
#        EOF
#  }
#}