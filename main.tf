resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "dev_pub_sub" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev_pub_sub"
  }
}

resource "aws_internet_gateway" "dev_int_gtw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_int_gtw"
  }
}

resource "aws_route_table" "dev_pub_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_rt_table"
  }
}

resource "aws_route" "dev_rt" {
  route_table_id            = aws_route_table.dev_pub_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.dev_int_gtw.id
}
