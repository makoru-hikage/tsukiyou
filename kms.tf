resource "aws_kms_key" "moon_estate_bedrock_vault_key" {
  description             = "Sovereign CMK for Tsukiyou's Vault in the Moon Estate"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow The SRE Full Management"
        Effect = "Allow"
        Principal = {
          AWS = var.estate_maintainer_arn
        }
        Action   = "kms:*" # Full control for the Architect
        Resource = "*"
      },
      {
        Sid    = "Allow Tsukiyou Cryptographic Usage"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.tsukiyou_identity.arn
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      }
    ]
  })
}
