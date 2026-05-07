provider "aws" {
  region = "ap-south-1"
  profile = "terraform"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "vpc" {
  source      = "/home/svashishtha/terraform-demo/modules/vpc"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

module "ec2" {
  source    = "/home/svashishtha/terraform-demo/modules/ec2"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  ami       = data.aws_ami.amazon_linux.id
}