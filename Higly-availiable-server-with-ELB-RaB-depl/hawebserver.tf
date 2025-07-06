#----------------------------------------------------------------
#                    
#                           Made by greysquare
#                         Zero Downown Web Server    
#
#----------------------------------------------------------------
provider "aws" {
    region = "us-east-1"
}
#--------------------------------Data--------------------------------

data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_ami" "latest_ubuntu"{
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
}

#--------------------------------Dynamic Security Group--------------------------------

resource "aws_security_group" "web" {
  name        = "greysquare"
  description = "Allow HTTP and HTTPS traffic"
  dynamic "ingress" {
  for_each = ["80", "443", "22", "21", "23"]
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
    Name = "allow_80 "
  }
}

#--------------------------------Launch Configuration--------------------------------

resource "aws_launch_template" "web" {
#    name = "web"
    name_prefix = "WebHALC-"
    image_id = data.aws_ami.latest_ubuntu.id
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.web.id]
    user_data = base64encode(templatefile("web.sh.tpl", {
        names = ["Vasya", "Dima", "Gena"]
        list  = ["apache2", "curl", "htop", "docker.io"]
        owner = "greysquare"
      }))
      lifecycle {
        create_before_destroy = true
      }
}

#--------------------------------Auto Scaling Group--------------------------------

resource "aws_autoscaling_group" "web" {
    name = "ASG-${aws_launch_template.web.name}"
    min_size = 2
    max_size = 3
    desired_capacity = 2
    vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
    load_balancers = [aws_elb.web.name]
    health_check_type = "ELB"
    health_check_grace_period = 300
    termination_policies = ["OldestInstance"]
    launch_template {
	id = aws_launch_template.web.id
        version = "$Latest"
    }    
    dynamic "tag" {
        for_each = {
            Name = "Webserver ASG"
            Owner = "greysquare"
            TAGKEY = "TAGVALUE"
        }
        content {
            key = tag.key
            value = tag.value
            propagate_at_launch = true
        }
    }

    lifecycle {
        create_before_destroy = true
    }
}

#--------------------------------Load Balancer--------------------------------

resource "aws_elb" "web" {
    name = "WebServer-HA-ELB"
    availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
    security_groups = [aws_security_group.web.id]
    listener {
        instance_port = 80
        instance_protocol = "HTTP"
        lb_port = 80
        lb_protocol = "HTTP"
    }
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/index.html"
        interval = 15
    }
    tags = {
        Name = "WebServer-HA-ELB"
        Owner = "greysquare"
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_default_subnet" "default_az1" {
    availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
    availability_zone = data.aws_availability_zones.available.names[1]
}


#--------------------------------Output --------------------------------

output "available_zones" {
    value = data.aws_availability_zones.available.names
} 

output "latest_ubuntu" {
    value = data.aws_ami.latest_ubuntu.id
}

output "web_load_balancer_url" {
    value = aws_elb.web.dns_name
}


