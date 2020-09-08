terraform {
    required_version = "~> 0.13"
    backend "s3" {
        bucket = "github-cloud-proxy-terraform-state"
        key = "infrastructure-global/container-repo/terraform.tfstate"
        region = "eu-west-2"
    }
}

provider "aws" {
    region = "eu-west-2"
}

resource "aws_ecr_repository" "github_cloud_proxy_container_repository" {
    name = "github-cloud-proxy"
}