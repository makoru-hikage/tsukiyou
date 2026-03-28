output "moon_estate_bedrock_vault_key_id" {
  value = aws_kms_key.moon_estate_bedrock_vault_key.key_id
  sensitive = true
}

output "moon_estate_bedrock_vault_key_arn" {
  value = aws_kms_key.moon_estate_bedrock_vault_key.arn
  sensitive = true
}

output "moon_estate_bedrock_vault_key_id_only" {
  value = aws_kms_key.moon_estate_bedrock_vault_key.id
  sensitive = true
}

output "moon_estate_id" {
  description = "The ID of the Moon Estate VPC"
  value       = aws_vpc.moon_estate.id
  sensitive   = true
}

output "tsukiyou_access_sg_id" {
  description = "SG for Bedrock Access"
  value       = aws_security_group.tsukiyou_access.id
  sensitive   = true
}

output "cloud_gate_sg_id" {
  description = "The NAT Instance / Seireimon-shimei SG"
  value       = aws_security_group.moon_estate_cloud_gate_sg.id
  sensitive   = true
}

output "tsukigumo_heartbeat_sg_id" {
  description = "Primary SG for the Gemma 3 Heartbeat Instance"
  value       = aws_security_group.tsukigumo_access.id
  sensitive   = true
}

output "spirit_gate_ssh_endpoint_sg_id" {
  description = "SG for the PrivateLink Interface Endpoint"
  value       = aws_security_group.tsukigumo_ssh_endpoint_sg.id
  sensitive   = true
}

output "mitome_in_plug_sg_id" {
  description = "The Plug-and-Play (Mitome-in) Security Group"
  value       = aws_security_group.tsukigumo_access_plug_sg.id
  sensitive   = true
}

# --- Subnet IDs (Gatehouses & Sanctums) ---

output "gatehouse_subnet_ids" {
  description = "Public Subnets for ingress/NAT"
  value       = [
    aws_subnet.moon_estate_public_a.id,
    aws_subnet.moon_estate_public_b.id,
    aws_subnet.moon_estate_public_c.id
  ]
  sensitive = true
}

output "sanctum_subnet_ids" {
  description = "Private Subnets where Tsukiyou and Tsukigumo reside"
  value       = [
    aws_subnet.moon_estate_private_a.id,
    aws_subnet.moon_estate_private_b.id,
    aws_subnet.moon_estate_private_c.id
  ]
  sensitive = true
}

# --- Gateway Metadata ---

output "main_gate_igw_id" {
  description = "The Internet Gateway ID"
  value       = aws_internet_gateway.main_gate.id
  sensitive   = true
}

output "s3_vault_gate_endpoint_id" {
  description = "The S3 Gateway Endpoint ID"
  value       = aws_vpc_endpoint.s3_vault_gate.id
  sensitive   = true
}

# --- Route Table IDs ---

output "public_route_table_id" {
  value     = aws_route_table.moon_estate_public_rtb.id
  sensitive = true
}

output "private_route_table_id" {
  value     = aws_route_table.moon_estate_private_rtb.id
  sensitive = true
}

output "aws_account_id" {
  value = var.aws_account_id
  sensitive = true
}
