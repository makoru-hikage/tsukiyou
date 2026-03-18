resource "aws_instance" "moon_estate_nat_bridge" {
  ami           = "ami-0327840715a6510bf" # AL2023 ARM64 in ap-northeast-2
  instance_type = "t4g.nano"
  subnet_id     = aws_subnet.moon_estate_public_a.id
  
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

  tags = { Name = "tsukigumo-seireimon" }
}
