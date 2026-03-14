resource "aws_s3_bucket" "tsukiyou_bedrock_vault" {
  bucket        = var.bedrock_vault_s3
  force_destroy = false 
}

# Standard Shielding
resource "aws_s3_bucket_public_access_block" "tsukiyou_bedrock_vault_acl" {
  bucket = aws_s3_bucket.tsukiyou_bedrock_vault.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# The Moon Estate's Default Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "tsukiyou_bedrock_vault_encryption" {
  bucket = aws_s3_bucket.tsukiyou_bedrock_vault.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
