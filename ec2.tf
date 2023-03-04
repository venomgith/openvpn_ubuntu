provider "aws" {
  access_key = ""                     # Your akey
  secret_key = "" # Your skey  
  region     = var.region
}

resource "aws_instance" "ovpnserv" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ovpn_sg.id]
  key_name               = aws_key_pair.ovpnssh.key_name
  user_data              = file("ovpn.sh")

  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }
  tags = var.tags
}

resource "aws_key_pair" "ovpnssh" {
  key_name   = "ovpnssh"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "OVPNSSH-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ovpnsshkey"
}

resource "aws_security_group" "ovpn_sg" {
  name        = "OVPNSC"
  description = "OVPNSC Terraform"

  ingress {
    description = "HTTP from WAN"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from WAN"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "OVPN from WAN"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from WAN"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Lan to Wan"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  description = "Public_IP_EC2"
  value       = aws_instance.ovpnserv.public_ip
}