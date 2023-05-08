terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}


data "aws_ami" "ubuntu" {

  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


resource "aws_instance" "web-server-instance" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"

  user_data = "${file("install.sh")}"
  user_data_replace_on_change = true

  tags = {
    Name = "hello-server"
  }

}
