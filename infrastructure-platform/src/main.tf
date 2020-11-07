terraform {
    required_version = "~> 0.13"
    backend "s3" {
        bucket = "github-cloud-proxy-terraform-state"
        key = "infrastructure-platform/terraform.tfstate"
        region = "eu-west-2"
    }
}

provider "aws" {
    region = "eu-west-2"
}