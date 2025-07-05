/* 
That`s a template for doing terraform instaces by greysquare
Start winth choose a proveder and configure the instances such as a
os, type of instance, region etc/
 */

provider "aws" {
    access_key      = "$ACCES_KEY"
    secret_key      = "$SECRET_KEY"
    region          = "us-east-1"
}

resource "aws_instance" "ubuntu_12new" {
    ami             = "ami-0a7d80731ae1b2435"
    instance_type   = "t2.micro"
}

resource "aws_instance" "ubuntu_22new" {
    ami             = "ami-0a7d80731ae1b2435"
    instance_type   = "t2.micro"
}

resource "aws_instance" "ubuntu_32new" {
    ami             = "ami-0a7d80731ae1b2435"
    instance_type   = "t2.micro"
}

/* 
If we need a few type the same instances we could add the string "count"
which doing upper there but in a few string of code
 */
resource "aws_instance" "ubuntu_32new" {
    count           = 3
    ami             = "ami-0a7d80731ae1b2435"
    instance_type   = "t2.micro"
}

/* 
by greysquare.inc
 */
