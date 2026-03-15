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
