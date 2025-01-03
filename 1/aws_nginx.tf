provider "aws" {
 region = "us-east-1"
}

resource "aws_instance" "greysquare" {
  ami                         = "ami-0e2c8caa4b6378d8c"" // Ubuntu
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.greysquare.id]
  user_data                   = file("ubuntu.sh") // Script
  user_data_replace_on_change = true
  tags = {
    Name  = "WebServer Ubuntu"
    Owner = "greysquare"
  }

resource "aws_instance" "greysquare" {
  ami                         = "ami-07a0da1997b55b23e" // Amazon Linux
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.greysquare.id]
  user_data                   = file("alma.sh") // Script
  user_data_replace_on_change = true                 
  tags = {
    Name  = "WebServer Amazon linux"
    Owner = "greysquare"
  }

resource "aws_security_group" "greysquare" {
  name        = "greysquare"
  description = "greysquare_security_group"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer by Terraform"
    Owner = "greysquare"
  }
}
