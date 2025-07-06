
provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "id" {}
data "aws_region" "region" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "prod_vpc"{
	 depends_on = [aws_instance.prod]
         tags = {
          Name = "prod"
        }
}
resource "aws_instance" "prod" {
    ami             = "ami-0c803b171269e2d72"
    instance_type   = "t2.micro"
    tags = {
      Name = "prod"
 }
}

resource "aws_subnet" "prod_subnet_1" {
        vpc_id = data.aws_vpc.prod_vpc.id
        availability_zone = data.aws_availability_zones.working.names[0]
        cidr_block = "10.10.1.0/24"
        tags = {
          Name = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
        }
}

output "prod_vpc_id" {
     value = data.aws_vpc.prod_vpc.id
	depends_on = [aws_instance.prod]
 }

output "data_aws_availability_zones" {
     value = data.aws_availability_zones.working.names
 }

output "data_aws_caller_identity" {
     value = data.aws_caller_identity.id.account_id
 }

output "data_aws_region" {
     value = data.aws_region.region.region
 }

output "data_aws_vpc" {
     value = data.aws_vpcs.my_vpcs.ids
 }

