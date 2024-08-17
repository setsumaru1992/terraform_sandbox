provider "aws" {
  region = "ap-northeast-1"
}

# terraform {
#   backend "s3" {
#     bucket = "terraform-sandbox-20240817"
#     key = "global/s3/terraform.tfstate"
#     region = "ap-northeast-1"
#     dynamodb_table = "terraform-up-and-running-locks"
#     encrypt = true
#   }
# }

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-sandbox-20240817"

  lifecycle {
    # trueにすると、terraform destroyなどでのリソース削除を禁止にする
    # ただ、企業プロダクトの開発でなければ大げさにS3を利用する必要はないのでfalseに
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}