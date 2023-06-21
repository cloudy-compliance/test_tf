terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    bucket = "tf-state-davy"
    region = "us-west-2"
    key    = "state.tfstate"
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_vpc" "vpc_app_server" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_subnet" "app_server_subnet" {
  vpc_id            = aws_vpc.vpc_app_server.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_network_interface" "app_server_interface" {
  subnet_id   = aws_subnet.app_server_subnet.id
  private_ips = ["192.168.0.100"]

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0f2cac3566b12dcb6"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.app_server_interface.id
    device_index         = 0
  }

  tags = {
    Name = "ExampleAppServerInstance43"
  }
}
