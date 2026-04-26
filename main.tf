provider "aws" {
  region  = "ap-south-1"
  profile = "terraform"
}

resource "aws_vpc" "demo" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "demo-vpc"
    }
}

resource "aws_subnet" "public" {
    vpc_id                   = aws_vpc.demo.id
    cidr_block               = "10.0.1.0/24"
    map_public_ip_on_launch  = true

    tags = {
      Name = "public-subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.demo.id

    tags = {
      Name = "demo-igw"
    }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "rta" {
    subnet_id       = aws_subnet.public.id
    route_table_id  = aws_route_table.rt.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "demo" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "vpc-ec2"
  }
}


