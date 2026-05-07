resource "aws_security_group" "sg" {
    name   = "dev-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
         from_port   = 80
         to_port     = 80
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    ="-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "dev-ec2"
  }
}
