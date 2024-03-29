# ---- doa network-vpc/main.tf -----

data "aws_availability_zones" "available" {}

resource "aws_vpc" "doa_vpc" {
  cidr_block           = var.doa_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "doa_vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "doa_subnet_web01_public" {
  vpc_id                  = aws_vpc.doa_vpc.id
  cidr_block              = var.doa_subnet_web01_public_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "doa_subnet_web01_public"
  }
}

resource "aws_subnet" "doa_subnet_web02_public" {
  vpc_id                  = aws_vpc.doa_vpc.id
  cidr_block              = var.doa_subnet_web02_public_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "doa_subnet_web02_public"
  }
}

resource "aws_subnet" "doa_subnet_app01_private" {
  vpc_id                  = aws_vpc.doa_vpc.id
  cidr_block              = var.doa_subnet_app01_private_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "doa_subnet_app01_private"
  }
}

resource "aws_subnet" "doa_subnet_app02_private" {
  vpc_id                  = aws_vpc.doa_vpc.id
  cidr_block              = var.doa_subnet_app02_private_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "doa_subnet_app02_private"
  }
}

resource "aws_subnet" "doa_subnet_db01_private" {
  vpc_id                  = aws_vpc.doa_vpc.id
  cidr_block              = var.doa_subnet_db01_private_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "doa_subnet_db01_private"
  }
}

resource "aws_subnet" "doa_subnet_db02_private" {
  vpc_id                  = aws_vpc.doa_vpc.id
  cidr_block              = var.doa_subnet_db02_private_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "doa_subnet_db02_private"
  }
}

resource "aws_internet_gateway" "doa_internet_gateway" {
  vpc_id = aws_vpc.doa_vpc.id

  tags = {
    Name = "doa_igw"
  }
}

resource "aws_route_table" "doa_public_rt" {
  vpc_id = aws_vpc.doa_vpc.id

  tags = {
    Name = "doa_rt_public"
  }
}


resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.doa_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.doa_internet_gateway.id
}


resource "aws_route_table_association" "to_doa_subnet_web01_public" {
  subnet_id      = aws_subnet.doa_subnet_web01_public.id
  route_table_id = aws_route_table.doa_public_rt.id
}

resource "aws_route_table_association" "to_doa_subnet_web02_public" {
  subnet_id      = aws_subnet.doa_subnet_web02_public.id
  route_table_id = aws_route_table.doa_public_rt.id
}

resource "aws_route_table" "doa_private_rt" {
  vpc_id = aws_vpc.doa_vpc.id
  
  tags = {
    Name = "doa_rt_private"
  }
}

resource "aws_route_table_association" "to_doa_subnet_app01_private" {
  subnet_id      = aws_subnet.doa_subnet_app01_private.id
  route_table_id = aws_route_table.doa_private_rt.id
}

resource "aws_route_table_association" "to_doa_subnet_app02_private" {
  subnet_id      = aws_subnet.doa_subnet_app02_private.id
  route_table_id = aws_route_table.doa_private_rt.id
}

resource "aws_route_table_association" "to_doa_subnet_db01_private" {
  subnet_id      = aws_subnet.doa_subnet_db01_private.id
  route_table_id = aws_route_table.doa_private_rt.id
}

resource "aws_route_table_association" "to_doa_subnet_db02_private" {
  subnet_id      = aws_subnet.doa_subnet_db02_private.id
  route_table_id = aws_route_table.doa_private_rt.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.doa_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.doa_ngw.id
}

resource "aws_eip" "doa_nat_eip" {
  depends_on = [aws_internet_gateway.doa_internet_gateway]
}

resource "aws_nat_gateway" "doa_ngw" {
  allocation_id = aws_eip.doa_nat_eip.id
  subnet_id     = aws_subnet.doa_subnet_web02_public.id
  depends_on = [aws_internet_gateway.doa_internet_gateway]

  tags = {
    Name = "doa_ngw"
  }
}