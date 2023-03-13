# Terraform AWS EKS Flask Demo

This projects is a demo project to perform the following tasks:

* Setup an EKS cluster on AWS using terraform
* Setup an ECR on AWS using terraform
* Create a demo flask application
* Create a docker container for the flask application using terraform
* Upload the container to ECR using terraform
* Apply the flask application to the EKS cluster using kubectl

## Getting started

The easiest way to get started is to open the project with a VSCode dev container.

Prerequisites:

* Docker is is installed and running on the host
* VSCode extensions are installed:
  * https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack

The container includes all dependencies for the project to run:

```console
cd terraform

aws configure

terraform init
terraform plan
terraform apply

aws eks update-kubeconfig --region eu-central-1 --name eks_demo1
kubectl get svc

cd ../k8s
kubectl apply -f flask-app-deployment.yml
kubectl get svc
```
