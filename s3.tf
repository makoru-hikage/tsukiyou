# The Vault (S3 Bucket)
resource "aws_s3_bucket" "moon_estate_bedrock_vault" {
  bucket = var.bedrock_vault_s3
  tags = {
    Name = var.bedrock_vault_s3
  }
}

# The Seal (Public Access Block)
resource "aws_s3_bucket_public_access_block" "moon_estate_bedrock_vault_acl" {
  bucket = aws_s3_bucket.moon_estate_bedrock_vault.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# The Gating Policy (Restricts access ONLY to the VPC Endpoint)
resource "aws_s3_bucket_policy" "moon_estate_bedrock_vault_policy" {
  bucket = aws_s3_bucket.moon_estate_bedrock_vault.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AccessFromMoonEstateOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.moon_estate_bedrock_vault.arn,
          "${aws_s3_bucket.moon_estate_bedrock_vault.arn}/*"
        ]
        Condition = {
          StringNotEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.s3_vault_gate.id
          }
          ArnNotLike = {
            "aws:PrincipalArn" = [
              var.estate_maintainer_arn,
              "${var.estate_maintainer_arn}/*",
              "arn:aws:iam::${var.aws_account_id}:root"
            ]
          }
        }
      }
    ]
  })
}
