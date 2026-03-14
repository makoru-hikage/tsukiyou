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
