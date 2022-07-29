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
// provides a networking address for interation between IGW and subnet
resource "aws_route" "dev_rt" {
  route_table_id         = aws_route_table.dev_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_int_gtw.id
}


resource "aws_route_table_association" "dev_pub_assoc" {
  subnet_id      = aws_subnet.dev_pub_sub.id
  route_table_id = aws_route_table.dev_pub_rt.id
}


resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "dev sec group"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // input your IP address here
    //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "dev_sg"
  }
}

resource "aws_key_pair" "dev_env" {
  key_name   = "dev-key"
  public_key = file("~/.ssh/devenvkey.pub") // used file path function instead of direct key
}

resource "aws_instance" "dev_node" {
  ami                    = data.aws_ami.server_ami.id # us-west-2
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.dev_env.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  subnet_id              = aws_subnet.dev_pub_sub.id

  root_block_device {
    volume_size = 10
  }

  tags = {
    "Name" = "dev_node"
  }
}