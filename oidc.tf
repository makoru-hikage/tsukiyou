resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [
    "2b18947a6a9fc7764fd8b5fb18a863b0c6dac24f",
    "1c5877685003504186522c070c0c2e366052865c",
  ]

  tags = {
    Name = "github-actions-oidc"
  }
}

import {
  to = aws_iam_openid_connect_provider.github_actions
  id = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_role" "nidzukuri_github_actions" {
  name = "nidzukuri-github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:makoru-hikage/nidzukuri-arm64:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "nidzukuri_github_actions_packer" {
  name = "nidzukuri-packer"
  role = aws_iam_role.nidzukuri_github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PackerEC2Access"
        Effect = "Allow"
        Action = [
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:DescribeInstanceStatus",
          "ec2:RunInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2:CreateImage",
          "ec2:RegisterImage",
          "ec2:DeregisterImage",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:ModifyInstanceAttribute",
          "ec2:GetPasswordData"
        ]
        Resource = "*"
      }
    ]
  })
}

output "nidzukuri_github_actions_role_arn" {
  description = "The OIDC Role ARN for nidzukuri GitHub Actions"
  value       = aws_iam_role.nidzukuri_github_actions.arn
  sensitive   = true
}
