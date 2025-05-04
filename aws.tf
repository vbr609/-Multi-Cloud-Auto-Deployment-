provider "aws" {
  region = "us-east-1"
}

# Key Pair
resource "aws_key_pair" "pubkey" {
  key_name   = "my-key-pair"
  public_key = local.public_key_content
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

# Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.0.0/24"
}

# Security Group
resource "aws_security_group" "my_sg" {
  name        = "allow_traffic"
  description = "Allow inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP-Application"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances
resource "aws_instance" "my_instances" {
  count                  = 2  # Provision 2 EC2 instances
  ami                    = "ami-0e2c8caa4b6378d8c"  # Replace with your desired AMI
  instance_type          = "t2.micro"
  associate_public_ip_address = true
  security_groups        = [aws_security_group.my_sg.name]
  key_name               = aws_key_pair.pubkey.key_name

  tags = {
    Name = "aws-instance-${count.index + 1}"  # Unique name for each instance
  }

  depends_on = [aws_key_pair.pubkey]
}

# Output the public IPs of the EC2 instances
output "aws_public_ips" {
  value = aws_instance.my_instances[*].public_ip
}