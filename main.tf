provider "aws" {
<<<<<<< HEAD
    region   = "ap-south-1"
    profile  = "terraform"
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
=======
  region = "ap-south-1"
}

# force Terraform to NOT use any local profile
  shared_config_files      = []
  shared_credentials_files = []

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-EC2"
  }
>>>>>>> 2842ef6ea981597582e8e62893c32d67119cac4c
}
