# 1. the moon estate (the sovereign vpc)
resource "aws_vpc" "moon_estate" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "moon-estate" }
}

# 2. the gatehouses (public subnets)
resource "aws_subnet" "moon_estate_public_a" {
  vpc_id                  = aws_vpc.moon_estate.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = { 
    Name        = "moon-estate-gatehouse-a",
    SUBNET_TYPE = "GATEHOUSE" 
  }
}

resource "aws_subnet" "moon_estate_public_b" { 
  vpc_id            = aws_vpc.moon_estate.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2b"
  tags = { 
    Name        = "moon-estate-gatehouse-b-void",
    SUBNET_TYPE = "GATEHOUSE" 
  }
}

resource "aws_subnet" "moon_estate_public_c" {
  vpc_id                  = aws_vpc.moon_estate.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = { 
    Name        = "moon-estate-gatehouse-c",
    SUBNET_TYPE = "GATEHOUSE" 
  }
}

# 3. the sanctums (private subnets)
resource "aws_subnet" "moon_estate_private_a" {
  vpc_id            = aws_vpc.moon_estate.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-2a"
  tags = { 
    Name        = "moon-estate-sanctum-a",
    SUBNET_TYPE = "SANCTUM" 
  }
}

resource "aws_subnet" "moon_estate_private_b" { 
  vpc_id            = aws_vpc.moon_estate.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-2b"
  tags = { 
    Name        = "moon-estate-sanctum-b-void",
    SUBNET_TYPE = "SANCTUM" 
  }
}

resource "aws_subnet" "moon_estate_private_c" {
  vpc_id            = aws_vpc.moon_estate.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-northeast-2c"
  tags = { 
    Name        = "moon-estate-sanctum-c",
    SUBNET_TYPE = "SANCTUM" 
  }
}

# 4. the main gate (internet gateway)
resource "aws_internet_gateway" "main_gate" {
  vpc_id = aws_vpc.moon_estate.id
  tags   = { Name = "moon-estate-igw" }
}


# 2. Public Route Table (For the Outer Court)
resource "aws_route_table" "moon_estate_public_rtb" {
  vpc_id = aws_vpc.moon_estate.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gate.id
  }

  tags = { Name = "moon-estate-public-rtb" }
}

# 3. Public Associations (For Subnets A and C)
resource "aws_route_table_association" "moon_estate_public_a_rtba" {
  subnet_id      = aws_subnet.moon_estate_public_a.id
  route_table_id = aws_route_table.moon_estate_public_rtb.id
}

resource "aws_route_table_association" "moon_estate_public_c_rtba" {
  subnet_id      = aws_subnet.moon_estate_public_c.id
  route_table_id = aws_route_table.moon_estate_public_rtb.id
}

# 4. Private Route Table (The Inner Sanctuary - No IGW path)
resource "aws_route_table" "moon_estate_private_rtb" {
  vpc_id = aws_vpc.moon_estate.id
  tags   = { Name = "moon-estate-private-rtb" }
}

# 5. Private Associations (Where Tsukiyou will reside)
resource "aws_route_table_association" "moon_estate_private_a_rtba" {
  subnet_id      = aws_subnet.moon_estate_private_a.id
  route_table_id = aws_route_table.moon_estate_private_rtb.id
}

resource "aws_route_table_association" "moon_estate_private_b_rtba" {
  subnet_id      = aws_subnet.moon_estate_private_b.id
  route_table_id = aws_route_table.moon_estate_private_rtb.id
}

resource "aws_route_table_association" "moon_estate_private_c_rtba" {
  subnet_id      = aws_subnet.moon_estate_private_c.id
  route_table_id = aws_route_table.moon_estate_private_rtb.id
}

resource "aws_route" "moon_estate_cloud_gate_nat_route" {
  route_table_id = aws_route_table.moon_estate_private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = aws_instance.moon_estate_nat_bridge.primary_network_interface_id
}

# The Secret Gate to the Archive (S3 Gateway Endpoint)
resource "aws_vpc_endpoint" "s3_vault_gate" {
  vpc_id            = aws_vpc.moon_estate.id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"

  # This is the "Magic" - it injects the S3 route into the Sanctuary
  route_table_ids = [aws_route_table.moon_estate_private_rtb.id]

  tags = {
    Name = "moon-estate-vault-gate"
  }
}
