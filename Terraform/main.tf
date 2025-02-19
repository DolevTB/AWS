terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}
#resource "aws_key_pair" "my_key" {
#   key_name   = "dolev_list"
#    public_key = file("/home/ec2-user/.ssh/id_rsa.pub")
#}

resource "aws_instance" "app_server" {
  ami           = "ami-053a45fff0a704a47"
  instance_type = "t2.micro"
  subnet_id            = "subnet-0f7b7bdb55981e7de"
  vpc_security_group_ids = ["sg-0615c1adc1c9b0cdc"]
  key_name      = "dolev" #aws_key_pair.my_key.key_name
  associate_public_ip_address = "true"
  tags = {
    Name = "Dolev-example"
    Owner = "dolevgeva"
  }
}
