#That`s new zero-down server
#
#
provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "web" {
  name        = "greysquare"
  description = "Allow HTTP and HTTPS traffic"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_80"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0c803b171269e2d72"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = "ssh-key-us1"
  user_data = templatefile("web.sh.tpl", {
    names = ["Vasya", "Dima", "Gena"] 
    list  = ["httpd", "curl", "htop", "docker.io"]
    owner = "greysquare"
  })
##That`s doing elatic ip service from instance web
resource "aws_eip" "my_static ip" {
	instance = aws_instance.web.id
}
## ignore changes that`s module that ignore other module that can be changed, prevent destroy, that`s when some changes in terraform
## file was done terraform can`t be reloaded - recreated for apply changes, create_f_d = true it`s creating server before destroy main server
   lifecycle {
   ignore_changes = ["ami", "user_data"]
   prevent_destroy = true
   create_before_destroy = true
}

  tags = {
    Name  = "webserver"
    Owner = "greysquare"
  }
}
