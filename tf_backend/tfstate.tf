# backend.tf

provider "aws" {
  region = "ap-northeast-2" # Please use the default region ID
}

# S3 버킷을 생성한다 (S3는 리전 내 중복 이름 설정 불가)
resource "aws_s3_bucket" "for_tfstate" {
  bucket = "s3-name" #######버킷 이름 설정 (고유해야 함)
}

# S3 버킷의 버저닝 기능 활성화 선언한다.
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.for_tfstate.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "table-name" ########테이블 이름 설정
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
