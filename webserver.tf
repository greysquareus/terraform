#---------------------------------------
# Bulding WebServer during Bootstrap
#
#By greysquare
#
#-----------------------

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


--[[ ---------------
 That`s added sec group for web server 
 This sec group`s rules avaliable only in this sec group
 For this moment aws advice use new type of rules which is NOT DEPENDS OF SECGROUP
 Examle of new type above there

 ---------------------------
 That`s just  SEC GROUP
resource "aws_security_group" "allow_tls(name)" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

Just here it`s indepedent sec rule 
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = aws_vpc.main.ipv6_cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

---------------- ]]

resource "aws_instance" "web" {
  ami                    = "ami-0c803b171269e2d72"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
/*
That`s more better way to get the script without adding title of script in tf file
  user_data = file("PATH.SH")
*/
  user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl -s https://api.ipify.org`
/*#myip=`hostname -I`
#myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
*/
echo "<h2>Webserver with IP: $myip</h2><br>Build by greysquare!" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF

  tags = {
    Name  = "webserver"
    Owner = "greysquare"
  }
}
