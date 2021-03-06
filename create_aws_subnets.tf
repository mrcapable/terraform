# Create new infrastructure on the aws cloud
# creates a vpc and subnets

# Variables
variable "aws_access_key"  {}
variable "aws_secret_key"  {}
variable "private_key_path" {}
variable "vpc_cidr_block"  {}
variable "vpc_name"  {}
variable "subnet_names" {
  type = "list"
}
variable "subnet_cidr_block" {
  type = "list"
}
variable "key_name" {
    default = "keyAWS2"

}

# Providers
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
  region = "eu-west-2"
}

# Resources

#VPC
resource "aws_vpc" "CreateVPC" {
  cidr_block = "${var.vpc_cidr_block}"

tags = {
    Name = "${var.vpc_name}"
}
}

#Subnets
resource "aws_subnet" "CreateSub" {
count = "${length(var.subnet_names)}"  #number of requested subnets
vpc_id            = "${aws_vpc.CreateVPC.id}"   #id from VPC created previously
cidr_block        = "${var.subnet_cidr_block[count.index]}"  # cidr block from supplied list

  tags {
    Name = "${var.subnet_names[count.index]}" 
}}


#Security groups
resource "aws_security_group" "sg_app_https" {
  name        = "sg_app_https"
  description = "Allow access to AppServer"
  vpc_id      = "${aws_vpc.CreateVPC.id}"   #id from VPC created previously

  ingress {
    # HTTP
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
    # HTTPS
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
    # SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

     egress {
    # HTTPS
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
     }

  tags = {
    Name = "sg_app_https"
  }
}

resource "aws_security_group" "sg_db_mysql" {
  name        = "sg_db_mysql"
  description = "Allow access to database"
  vpc_id      = "${aws_vpc.CreateVPC.id}"   #id from VPC created previously

    ingress {
    # SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    # MySQL
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = "${var.subnet_cidr_block}"
    } 

  tags = {
    Name = "sg_db_mysql"
  }
 }

#Route tables
#resource "aws_route" "rt_allow" {
 # count                     = "${length(data.aws_route_tables.rts.ids)}"
 d  #route_table_id            = "${data.aws_route_tables.rts.ids[count.index]}"
  #destination_cidr_block    = "10.0.1.0/22"
  #vpc_peering_connection_id = "pcx-0e9a7a9ecd137dc54"
#}

#Elatic IP for NAT gateway
resource "aws_eip" "eip_nat" {
    tags = {
    Name = "eip_nat"
}
}
# Choose public subnet to house NAT gateway
# Retrieve all subnet ids, we are assuming the first subnet will be public
# facing to host the NAT gateway
#data "aws_subnet_ids" "GetPublicSubnetDetails" {
#vpc_id = "${aws_vpc.CreateVPC.id}"

#}

#resource "aws_nat_gateway" "NATgw" {
 # allocation_id = "${aws_eip.eip_nat.id}"
  #subnet_id     = "${data.aws_subnet_ids.GetPublicSubnetDetails.ids[0]}"  #the subnet id of the first subnet...assuming it is public.


#tags = {
 #   Name = "NatGW"
  #}
#}