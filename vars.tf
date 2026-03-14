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
