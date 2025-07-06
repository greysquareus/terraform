#---------------------------------------
# Bulding Dynamic SecGroup
#
#By greysquare
#
#-----------------------


resource "aws_security_group" "web" {
  name        = "greysquare"
  description = "Allow HTTP and HTTPS traffic"
  dynamic "ingress" {
# cycle of ports which needs to open
  for each = ["80", "555", "443", "22", "21", "23"]
  content {	   
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


  }
}

#If we need special rule for some port it`s doing like before
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
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

