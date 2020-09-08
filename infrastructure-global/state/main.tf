terraform {
  required_version = "~> 0.13"
    backend "s3" {
      bucket = "github-cloud-proxy-terraform-state"
      key    = "infrastructure-global/state/terraform.tfstate"
      region = "eu-west-2"
    }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_dynamodb_table" "s3-state-lock-table" {
  name = "github-cloud-proxy-terraform-state-lock"

  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "terraform-state-s3-bucket" {
  bucket = "github-cloud-proxy-terraform-state"

  #   lifecycle {
  #     prevent_destroy = true
  #   }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}