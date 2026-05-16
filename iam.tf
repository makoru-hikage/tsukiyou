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

resource "aws_iam_role" "moon_estate_packer_attached" {
  name = "moon-estate-packer-attached"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "moon_estate_packer_attached_cloudwatch" {
  name = "cloudwatch_policy"
  role = aws_iam_role.moon_estate_packer_attached.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchReadAccess"
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "cloudwatch:DescribeAlarmsForMetric",
          "tag:GetResources"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "moon_estate_packer_attached" {
  name = "moon-estate-packer-attached"
  role = aws_iam_role.moon_estate_packer_attached.name
}

resource "aws_iam_role" "moon_estate_observatory" {
  name = "moon-estate-observatory"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "moon_estate_observatory_policy" {
  name = "cloudwatch_policy"
  role = aws_iam_role.moon_estate_observatory.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "tag:GetResources",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "apigateway:GET",
          "aps:ListWorkspaces",
          "autoscaling:DescribeAutoScalingGroups",
          "dms:DescribeReplicationInstances",
          "dms:DescribeReplicationTasks",
          "ec2:DescribeTransitGatewayAttachments",
          "ec2:DescribeSpotFleetRequests",
          "shield:ListProtections",
          "storagegateway:ListGateways",
          "storagegateway:ListTagsForResource",
          "iam:ListAccountAliases"
        ],
        Resources = ["*"]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "moon_estate_observatory_instance_profile" {
  name = "moon-estate-observatory-profile"
  role = aws_iam_role.moon_estate_observatory.name
}

# --- Tsukigumo is dormant. Her c7g is gone. Commented out until she returns. ---

# resource "aws_iam_role" "tsukigumo_identity" {
#   name = "tsukigumo-no-shimei"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = "sts:AssumeRole"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
#
#   tags = {
#     Name = "tsukigumo-no-shimei"
#     Task = "Gemma-3-Heartbeat"
#   }
# }

# resource "aws_iam_role_policy" "tsukigumo_vault_access" {
#   name = "TsukiyouVaultAccess"
#   role = aws_iam_role.tsukigumo_identity.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "ReadWriteVault"
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:ListBucket"
#         ]
#         Resource = [
#           "arn:aws:s3:::${aws_s3_bucket.moon_estate_bedrock_vault.id}",
#           "arn:aws:s3:::${aws_s3_bucket.moon_estate_bedrock_vault.id}/*"
#         ]
#       },
#       {
#         Sid    = "UseSovereignKey"
#         Effect = "Allow"
#         Action = [
#           "kms:Decrypt",
#           "kms:DescribeKey",
#           "kms:GenerateDataKey*",
#           "kms:ReEncrypt*"
#         ]
#         Resource = [aws_kms_key.moon_estate_bedrock_vault_key.arn]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "tsukigumo_ssm_attachment" {
#   role       = aws_iam_role.tsukigumo_identity.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_instance_profile" "tsukigumo_profile" {
#   name = "tsukigumo-no-karada"
#   role = aws_iam_role.tsukigumo_identity.name
# }
