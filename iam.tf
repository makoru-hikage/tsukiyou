resource "aws_iam_role" "tsukiyou_identity" {
  name = "tsukiyou-no-kenzoku"
  assume_role_policy = jsonencode({})
}

import {
  to = aws_iam_role.tsukiyou_identity
  id = "tsukiyou-no-kenzoku"
}

resource "aws_iam_role_policy" "tsukiyou_vault_access" {
  name = "TsukiyouVaultAccess"
  role = aws_iam_role.tsukiyou_identity.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadWriteVault"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.moon_estate_bedrock_vault.id}",
          "arn:aws:s3:::${aws_s3_bucket.moon_estate_bedrock_vault.id}/*"
        ]
      },
      {
        Sid    = "UseSovereignKey"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ]
        Resource = [aws_kms_key.moon_estate_bedrock_vault_key.arn]
      }
    ]
  })
}
