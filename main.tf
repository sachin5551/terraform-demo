provider "aws" {
    region   = "ap-south-1"
}

data "aws_ami" "amazon_linux" {
    most_recent = true

    owners = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "my_ec2" {
    ami            = data.aws_ami.amazon_linux.id
    instance_type  = "t3.micro"

    tags = {
      Name = "Terraform-EC2"
    }
}
