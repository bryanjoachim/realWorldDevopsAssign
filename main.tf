provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true    
  enable_dns_hostnames = true 
}


resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "web_sg" {
  name = "web_sg"
  description = "allow http and ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }



  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "web" {
    ami = var.ami_id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_a.id
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    key_name = var.key_name

    user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3

              # Wait until Python is actually available
              until command -v python3 >/dev/null 2>&1; do
              echo "Waiting for Python to be installed..."
              sleep 5
              done

              # Optional: create symlinks for Ansible
              ln -s /usr/bin/python3 /usr/bin/python || true
              ln -s /usr/bin/python3 /usr/bin/python3.8 || true
              EOF

    tags = {
      name = "Web server"
    }
}



