provider "aws" {
  region = "us-east-1"
  profile = "tfuser"
}

resource "aws_instance" "web" {
  ami           = "ami-011939b19c6bd1492"
  instance_type = "t2.micro"
  key_name = "master"
  vpc_security_group_ids = ["sg-0ea6ac3a80c3d7e36"] 
  
user_data = <<-EOF
  #!/bin/bash  
  sudo yum install wget -y
EOF
  tags = {
    Name = "TEST"
    role = "web"
  }
}
