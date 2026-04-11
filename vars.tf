variable "bedrock_vault_s3" {
  type = string
  description = "The name of Tsukiyou's vault, an S3 bucket."
}

variable "estate_maintainer_arn" {
  type = string
  description = "The caretaker of the estate"
}

variable "aws_account_id" {
  type = string
  sensitive = true
}

variable "the_developer_email" {
  type = string
  description = "Hi!"
  default = "kurt_ma.coll@live.com"
}

# Only used by a summon workflow when a particular VPC interface gateway is opened
variable "spirit_gate_subnet" {
  type = string
  description = "Used to summon an ephemeral interface gateway."
  default = "private_a"
}

variable "spirit_gate_open" {
  type        = string
  description = "Will the gate open? 'true' or 'false' only"
  default     = "false"
  
  validation {
    condition     = contains(["true", "false"], var.spirit_gate_open)
    error_message = "The spirit_gate_open variable must be exactly 'true' or 'false'."
  }
}

