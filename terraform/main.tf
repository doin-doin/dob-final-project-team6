# version.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket         = "s3-name" #버킷 이름 설정
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "table-name" #테이블 이름 설정
    encrypt        = true
  }

  required_version = ">= 1.0.11"
}

provider "aws" {
  region = "ap-northeast-2"
  # access_key = var.AWS_ACCESS_KEY_ID
  # secret_key = var.AWS_SECRET_ACCESS_KEY
}

locals {
  s3_bucket_name = "s3-name" #버킷 이름 설정
}
