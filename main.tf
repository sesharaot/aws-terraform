provider "aws" {
  region = "us-east-1"
  profile = "tfuser"
}

resource "aws_instance" "web" {
  ami           = "ami-011939b19c6bd1492"
  instance_type = "t3.micro"

  tags = {
    Name = "TEST"
    role = "web"
  }
}
