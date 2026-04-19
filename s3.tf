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
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.moon_estate_bedrock_vault.arn,
          "${aws_s3_bucket.moon_estate_bedrock_vault.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.s3_vault_gate.id
          }
          ArnLike = {
            "aws:PrincipalArn" = [
              var.estate_maintainer_arn,
              "${var.estate_maintainer_arn}/*",
              "arn:aws:iam::${var.aws_account_id}:root"
            ]
          }
        }
      },
      {
            Sid =  "TakonekoMaintenance"
            Effect = "Allow"
            Principal = "*"
            Action = [
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:GetAccelerateConfiguration",
                "s3:GetBucketAcl",
                "s3:GetAnalyticsConfiguration",
                "s3:GetBucketLocation",
                "s3:GetBucketLogging",
                "s3:GetBucketOwnershipControls",
                "s3:GetBucketPolicy",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetBucketTagging",
                "s3:GetBucketVersioning",
                "s3:PutBucketTagging"
            ],
            Resource = aws_s3_bucket.moon_estate_bedrock_vault.arn
            Condition = {
              ArnLike = {
                "aws:PrincipalArn" = [
                  var.github_oidc_role_arn,
                  "${var.github_oidc_role_arn}/*",
                ]
              }
            }
        },
      {
        Sid    = "BedrockLoggingWrite"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.bedrock_logging_role.arn
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.moon_estate_bedrock_vault.arn}/bedrock-logs/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-server-side-encryption" = "aws:kms"
          }
        }
      }
    ]
  })
}
