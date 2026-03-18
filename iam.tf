resource "aws_iam_role" "tsukiyou_identity" {
  name = "tsukiyou-no-kenzoku"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
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

resource "aws_iam_role" "moon_estate_cloud_gate_role" {
  name = "tsukigumo-seireimon-shimei"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "moon_estate_cloud_gate_role_ap_ssm" {
  role       = aws_iam_role.moon_estate_cloud_gate_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "moon_estate_cloud_gate_role_profile" {
  name = "tsukigumo-seireimon-no-karada"
  role = aws_iam_role.moon_estate_cloud_gate_role.name
}
