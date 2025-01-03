provider  "aws" {
    region     = "us-east-1"
}

 resource  "aws_instance" "Ubuntu_web" {
    ami                    = "ami-0e2c8caa4b6378d8c"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.greysquare.id]
    user_data              = file("nginx.sh")

    tags = {
        Name  = "web_server"
        Owner = "greysquare"
    }
 }

  resource  "aws_instance" "Ubuntu_app" {
    ami                    = "ami-0e2c8caa4b6378d8c"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.greysquare.id]

    tags = {
        Name  = "app_server"
        Owner = "greysquare"
    }
 }

  resource  "aws_instance" "Ubuntu_db" {
    ami                    = "ami-0e2c8caa4b6378d8c"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.greysquare.id]

    tags = {
        Name  = "db_server"
        Owner = "greysquare"
    }
 }

 resource "aws_security_group" "greysquare" {
    name = "greysquare"

    dynamic "ingress" {
        for_each = ["80", "443", "22"]
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Security group by greysquare"
    }
 }
