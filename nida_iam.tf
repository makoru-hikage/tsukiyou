resource "aws_iam_role" "nida_no_takoneko" {
  name = "nida-no-takoneko"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Effect = "Allow"
        Action = [
          "sts:AssumeRoleWithWebIdentity",
          "sts:TagSession"
        ]
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:luna-obscura@*/nida-tf@*:*"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "nida-no-takoneko"
    PROJECT     = "NIDA"
    ENVIRONMENT = "DEV"
  }
}

resource "aws_iam_role_policy" "nida_iam_policy" {
  name = "nida-iam-policy"
  role = aws_iam_role.nida_no_takoneko.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "NidaIAMPolicies"
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:CreateRole",
          "iam:CreateInstanceProfile",
          "iam:GetInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:ListAttachedRolePolicies",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:ListInstanceProfilesForRole",
          "iam:PassRole",
          "iam:ListInstanceProfileTags",
          "iam:TagInstanceProfile",
          "iam:UntagInstanceProfile",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:ListRolePolicies",
          "iam:UpdateAssumeRolePolicy",
          "iam:TagRole"
        ]

        Resource = [
          "arn:aws:iam::${var.aws_account_id}:role/nida-*",
          "arn:aws:iam::${var.aws_account_id}:instance-profile/nida-*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "nida_devops_policy" {
  name = "nida-devops-policy"
  role = aws_iam_role.nida_no_takoneko.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "NidaEC2Policies"
        Effect = "Allow"
        Action = [
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeTags",
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:ModifyVpcAttribute",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:ModifySubnetAttribute",
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateVpcEndpoint",
          "ec2:DeleteVpcEndpoints",
          "ec2:Describe*",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:AttachNetworkInterface",
          "ec2:AllocateAddress",
          "ec2:ReleaseAddress",
          "ec2:AssociateAddress",
          "ec2:DisassociateAddress"
        ]

        Resource = ["*"]
      },
      {
        Sid    = "NidaWebResourcePolicies"
        Effect = "Allow"
        Action = [
          "s3:*",
          "kms:*",
          "rds:*",
          "dynamodb:*",
          "elasticloadbalancing:*",
          "acm:*",
          "route53:*",
          "logs:*",
          "cloudwatch:*",
          "cloudfront:*"
        ]

        Resource = ["*"]
      },
      {
        Sid    = "NidaOrchestrationPolicies"
        Effect = "Allow"
        Action = [
          "ecs:*",
          "servicediscovery:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:DescribeRepositories",
          "ecr:ListTagsForResource",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:PutLifecyclePolicy",
          "ecr:GetLifecyclePolicy",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImageScanningConfiguration",
          "ecr:GetRepositoryPolicy",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:AssociateIamInstanceProfile",
          "ec2:DescribeIamInstanceProfileAssociations",
          "ec2:DisassociateIamInstanceProfile",
          "ec2:Modify*",
          "ec2:List*",
          "ec2:Describe*"
        ]

        Resource = ["*"]
      },
      {
        Sid    = "NidaLBPolicies"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:*",
          "autoscaling:*"
        ]

        Resource = ["*"]
      },
      {
        Sid    = "NidaServiceLinkedRoles"
        Effect = "Allow"
        Action = ["iam:CreateServiceLinkedRole"]
        Resource = [
          "arn:aws:iam::*:role/aws-service-role/rds.amazonaws.com/*",
          "arn:aws:iam::*:role/aws-service-role/ecs.amazonaws.com/*",
          "arn:aws:iam::*:role/aws-service-role/servicediscovery.amazonaws.com/*"
        ]
      },
      {
        Sid    = "NidaSecretsManagerRead"
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:GetResourcePolicy"
        ]
        Resource = ["arn:aws:secretsmanager:ap-northeast-2:${var.aws_account_id}:secret:nida/*"]
      },
      {
        Sid    = "NidaSecretsManagerWrite"
        Effect = "Allow"
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:TagResource",
          "secretsmanager:UntagResource"
        ]
        Resource = ["arn:aws:secretsmanager:ap-northeast-2:${var.aws_account_id}:secret:nida/*"]
      }
    ]
  })
}
