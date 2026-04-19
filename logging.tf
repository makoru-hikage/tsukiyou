# ============================================================
# 月陽の記録 — Bedrock Invocation Logging
# Sends Bedrock invocation logs to the Bedrock Vault
# Two folders:
#   - bedrock-logs/cloudwatch/ → Metadata (timestamps, token counts)
#   - bedrock-logs/full/       → Full text (input + output)
# ============================================================

# --- IAM Role for Bedrock to write to the Bedrock Vault ---
resource "aws_iam_role" "bedrock_logging_role" {
  name = "moon-estate-bedrock-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BedrockLoggingAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:bedrock:ap-northeast-2:${var.aws_account_id}:*"
          }
        }
      }
    ]
  })

  tags = {
    Name = "moon-estate-bedrock-logging-role"
    Task = "Bedrock Invocation Logging"
  }
}

# --- IAM Policy: Write logs to Bedrock Vault + CloudWatch + use sovereign KMS key ---
resource "aws_iam_role_policy" "bedrock_logging_policy" {
  name = "moon-estate-bedrock-logging-policy"
  role = aws_iam_role.bedrock_logging_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "WriteLogsToVault"
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.bedrock_vault_s3}/bedrock-logs/*"
        ]
      },
      {
        Sid    = "UseSovereignKeyForLogs"
        Effect = "Allow"
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = [aws_kms_key.moon_estate_bedrock_vault_key.arn]
      },
      {
        Sid    = "WriteToCloudWatch"
        Effect = "Allow"
        Action = [
          "logs:CreateLogDelivery",
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:ap-northeast-2:${var.aws_account_id}:log-group:/aws/bedrock/moon-estate/*"
      }
    ]
  })
}

# --- Bedrock Model Invocation Logging Configuration ---
# depends_on ensures IAM permissions and log group exist before Bedrock validates them
resource "aws_bedrock_model_invocation_logging_configuration" "moon_estate_logging" {
  depends_on = [
    aws_iam_role_policy.bedrock_logging_policy,
    aws_cloudwatch_log_group.moon_estate_bedrock_metadata_logs
  ]

  logging_config {

    # CloudWatch: Metadata only (no text content)
    cloudwatch_config {
      log_group_name = "/aws/bedrock/moon-estate/metadata"
      role_arn       = aws_iam_role.bedrock_logging_role.arn
    }

    # Bedrock Vault: Full text logging (input + output)
    s3_config {
      bucket_name = var.bedrock_vault_s3
      key_prefix  = "bedrock-logs/full"
    }

    # What to capture
    text_data_delivery_enabled      = true  # Full input/output text
    image_data_delivery_enabled     = false # No image models in use
    embedding_data_delivery_enabled = false # No embedding models in use
  }
}

# --- CloudWatch Log Group for Metadata ---
resource "aws_cloudwatch_log_group" "moon_estate_bedrock_metadata_logs" {
  name              = "/aws/bedrock/moon-estate/metadata"
  retention_in_days = 30 # 30 days then auto-expire

  tags = {
    Name = "moon-estate-bedrock-metadata-logs"
  }
}
