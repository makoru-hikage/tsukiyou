variable "bedrock_vault_s3" {
  type = string
  description = "The name of Tsukiyou's vault, an S3 bucket."
}

variable "estate_maintainer_arn" {
  type = string
  description = "The caretaker of the estate"
}

variable "github_oidc_role_arn" {
  type = string
  description = "The official Github contractor"
}

variable "aws_account_id" {
  type = string
}

# Only used by a summon workflow when a particular VPC interface gateway is opened
variable "spirit_gate_subnet" {
  type = string
  description = "Used to summon an ephemeral interface gateway."
}

