resource "aws_ecr_repository" "eks_demo" {
  name = "eks_demo"
}

resource "docker_image" "flask_demo" {
  name = local.flask_demo_image_url

  build {
    context    = "../"
    dockerfile = "Dockerfile.app"
  }
}

resource "docker_registry_image" "flask_demo" {
  name = docker_image.flask_demo.name
}

output "eks_demo_ecr_image_url" {
  value = local.flask_demo_image_url
}