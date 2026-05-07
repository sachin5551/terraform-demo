terraform {
  backend "s3" {
    bucket         = "sachin-terraform-state-demo-12345"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    profile        = "terraform"
  }
}