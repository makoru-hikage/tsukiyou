resource "aws_instance" "moon_estate_nat_bridge" {
  ami           = "ami-0327840715a6510bf" # AL2023 ARM64 in ap-northeast-2
  instance_type = "t4g.nano"
  subnet_id     = aws_subnet.moon_estate_public_a.id
  iam_instance_profile = aws_iam_instance_profile.moon_estate_cloud_gate_role_profile.name

  # CRITICAL: NAT instances must not check if they are the final destination
  source_dest_check = false 
  
  vpc_security_group_ids = [aws_security_group.moon_estate_cloud_gate_sg.id]

  # AL2023 Modern NAT Configuration
  user_data = <<-EOF
              #!/bin/bash
              yum install iptables-services -y
              systemctl enable iptables
              systemctl start iptables
              echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/custom-ip-forwarding.conf
              sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
              # Dynamically find the interface (usually ens5 on T4g) and apply Masquerade
              IFACE=$(ip route show default | awk '{print $5}')
              /sbin/iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE
              service iptables save
              EOF

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    # kms_key_id            = "AWS-MANAGED-KEY"
    delete_on_termination = true
  }


  capacity_reservation_specification {
    capacity_reservation_target {
      capacity_reservation_id = aws_ec2_capacity_reservation.nat_anchor.id
    }
  }

  tags = { Name = "tsukigumo-seireimon" }
}

resource "aws_ec2_capacity_reservation" "nat_anchor" {
  instance_type           = "t4g.nano"
  instance_platform       = "Linux/UNIX"
  availability_zone       = aws_subnet.moon_estate_public_a.availability_zone
  instance_count          = 1
  instance_match_criteria = "targeted"

  tags = {
    Name = "tsukiyashiki-nat-anchor"
  }
}

resource "aws_instance" "moon_estate_observatory" {
  ami           = "ami-0d7281a43fae8c8b1"
  instance_type = "t4g.micro"
  subnet_id     = aws_subnet.moon_estate_public_a.id
  iam_instance_profile = aws_iam_instance_profile.moon_estate_observatory_instance_profile
  
  vpc_security_group_ids = [aws_security_group.moon_estate_cloud_gate_sg.id]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    # kms_key_id            = "AWS-MANAGED-KEY"
    delete_on_termination = true
  }

  capacity_reservation_specification {
    capacity_reservation_target {
      capacity_reservation_id = aws_ec2_capacity_reservation.nat_anchor.id
    }
  }

  tags = { Name = "tsukiyashiki-kansokujo" }
}

resource "aws_ec2_capacity_reservation" "moon_estate_observatory_anchor" {
  instance_type           = "t4g.micro"
  instance_platform       = "Linux/UNIX"
  availability_zone       = aws_subnet.moon_estate_public_a.availability_zone
  instance_count          = 1
  instance_match_criteria = "targeted"

  tags = {
    Name = "tsukiyashiki-kansokujo-anchor"
  }
}
