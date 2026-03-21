resource "aws_security_group" "tsukiyou_access" {
  name        = "tsukiyou-access-sg"
  description = "Security group for Moon Estate Spirit Gate"
  vpc_id      = aws_vpc.moon_estate.id

  tags = {
    Name = "tsukiyou-access-sg"
  }
}

resource "aws_security_group_rule" "gate_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.moon_estate.cidr_block]
  security_group_id = aws_security_group.tsukiyou_access.id
}

resource "aws_security_group_rule" "gate_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # Allow all traffic out
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tsukiyou_access.id
}

resource "aws_security_group" "moon_estate_cloud_gate_sg" {
  name        = "tsukigumo-seireimon"
  description = "The NAT Instance Security Group"
  vpc_id      = aws_vpc.moon_estate.id

  tags = {
    Name = "tsukigumo-seireimon-sg"
  }
}

resource "aws_security_group_rule" "moon_estate_cloud_gate_sg_i_all" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [aws_vpc.moon_estate.cidr_block]
  security_group_id = aws_security_group.moon_estate_cloud_gate_sg.id
}

resource "aws_security_group_rule" "moon_estate_cloud_gate_sg_e_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.moon_estate_cloud_gate_sg.id
}

resource "aws_security_group" "tsukigumo_access" {
  name        = "tsukigumo-access-sg"
  description = "Security Group for Gemma 3 Heartbeat Instance"
  vpc_id      = aws_vpc.moon_estate.id
}

resource "aws_vpc_security_group_ingress_rule" "tsukigumo_access_i_ssh" {
  security_group_id            = aws_security_group.tsukigumo_access.id
  referenced_security_group_id = aws_security_group.tsukigumo_ssh_endpoint_sg
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  description                  = "SSH via PrivateLink Spirit Gate"
}

resource "aws_vpc_security_group_egress_rule" "tsukigumo_access_e_internet" {
  security_group_id = aws_security_group.tsukigumo_access.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Allow all for model pulls
  description       = "Egress for Ollama and updates"
}

resource "aws_security_group" "tsukigumo_ssh_endpoint_sg" {
  name        = "tsukigumo-ssh-endpoint-sg"
  description = "Security Group for the Interface Endpoint"
  vpc_id      = aws_vpc.moon_estate.id
}

resource "aws_vpc_security_group_egress_rule" "tsukigumo_ssh_endpoint_sg_e" {
  security_group_id            = aws_security_group.tsukigumo_ssh_endpoint_sg.id
  referenced_security_group_id = aws_security_group.tsukigumo_access.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  description                  = "Permit endpoint to reach instance"
}
