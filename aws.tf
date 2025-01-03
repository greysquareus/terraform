provider "aws" {
 region = "us-east-1"
}

resource "aws_instance" "Ubuntu" {
  count = 1
  ami = "ami-0c7af5fe939f2677f"
  instance_type = "t3.micro"
  tags = {
    Name    = "Ubuntu"
    Owner   = "greysquare1"
    Project = "terraform1"
  }
}

resource "aws_instance" "RedHat" {
  count = 1
  ami = "ami-0c7af5fe939f2677f"
  vpc_security_group_ids = [aws_security_group.greysquare.id]
  instance_type = "t3.micro"
  tags = {
    Name    = "Redhat"
    Owner   = "greysquare2"
    Project = "terraform2"
  }

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
myip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
}

