/*
That`s a template for doing terraform tags by greysquare
Acess_Key Secret key Region have to be in env by doing it on terminal above here
export AWS_ACCESS_KEY_ID=<ACCES>
export AWS_SECRET_ACCESS_KEY=<SECRET>
export AWS_DEFAULT_REGION=<REGION>
 */

provider "aws" {
    access_key      = "$ACCES_KEY"
    secret_key      = "$SECRET_KEY"
    region          = "us-east-1"
}


resource "aws_instance" "ubuntu_32new" {
    count           = 3
    ami             = "ami-0a7d80731ae1b2435"
    instance_type   = "t2.micro"

/*
Tags section allow to tag the instances how we need to identify some things 
 */
    tags  = {
    Name  = "Tag instance"
    Owner = "greysquare"
 }
}
