# Create subnets on different availability zones.
#  

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

resource "aws_vpc" "CreateVPC" {
  cidr_block = "${var.vpc_cidr_block}"

tags = {
    Name = "${var.vpc_name}"
}
}

resource "aws_subnet" "CreateSub" {
count = "${length(var.subnet_names)}"  #number of requested subnets
vpc_id            = "${aws_vpc.CreateVPC.id}"   #id from VPC created previously
cidr_block        = "${var.subnet_cidr_block[count.index]}"  # cidr block from supplied list

  tags {
    Name = "${var.subnet_names[count.index]}" 
}}



