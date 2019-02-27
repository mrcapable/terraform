# Create 3 ec2 instances with my named ami olalinux image 
#  on a t2.micro node with an AWS Tag naming it "v10"

# Variables
variable "aws_access_key"  {}
variable "aws_secret_key"  {}
variable "private_key_path" {}
variable "key_name" {
    default = "keyAWS"
}

# Providers
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
  region = "eu-west-2"
}


data "aws_ami" "ami_image" {
  # most_recent = true

  filter {
    name   = "name"
    values = ["olalinux"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["260608527087"]
}

resource "aws_instance" "Vm" {
  count =3 #number of ec2 instances to create
  ami           = "${data.aws_ami.ami_image.id}"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["sg-06b384b586eb6882f","sg-048310d37d4d554ed"]
  subnet_id = "subnet-0e07c66d6a79a486b"
  connection {
      user      = "ec2-user"
      private_key = "${file(var.private_key_path)}"
  tags = {
    Name = "v10${count.index}"  #variable names
  }
  }}
