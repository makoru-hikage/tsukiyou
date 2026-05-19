resource "aws_vpc_endpoint" "spirit_gate" {
  count             = tobool(var.spirit_gate_open) ? 1 : 0
  vpc_id            = aws_vpc.moon_estate.id
  service_name      = "com.amazonaws.ap-northeast-2.bedrock-runtime"
  vpc_endpoint_type = "Interface"

  # Manifesting in the selected AZ only to save costs
  subnet_ids         = [local.moon_estate_subnets[var.spirit_gate_subnet]]
  security_group_ids = [
    aws_security_group.tsukiyou_access.id,
    aws_security_group.tsukigumo_access.id
  ]

  private_dns_enabled = true
  tags = {
    Name = "seireimon"
  }
}

resource "aws_ec2_instance_connect_endpoint" "tsukigumo_sanctum_gate_a" {
  # The Gate should sit in the Private Subnet (Sanctum) 
  # to reach the instance directly via the VPC backplane.
  subnet_id          = aws_subnet.moon_estate_private_a.id 
  security_group_ids = [
    aws_security_group.tsukigumo_ssh_endpoint_sg.id,
    aws_security_group.tsukigumo_access.id
  ]

  tags = {
    Name = "tsukigumo-seireimon-ssh-gate"
  }
}
