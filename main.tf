terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration is injected via 'tofu init -backend-config=...' 
  # in the GitHub Action to keep the code portable and clean.
  # backend "s3" {}
}

provider "aws" {
  region = "ap-northeast-2"

  # These 'shouting' tags will be applied to every resource 
  # Silas creates within the Moon Estate.
  default_tags {
    tags = {
      PROJECT     = "TSUKIYOU"
      ENVIRONMENT = "PERSONAL"
      PROVISION   = "TERRAFORM"
    }
  }
}
