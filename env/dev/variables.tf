variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
}

variable "servers" {
  type = map(string)

  default = {
    web = "t3.micro"
    app = "t3.micro"
  }
}