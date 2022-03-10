provider "aws" {
  region = "us-east-1"
  profile = "tfuser"
}

resource "aws_instance" "web" {
  ami           = "ami-011939b19c6bd1492"
  instance_type = "t2.micro"
  
  user_data = <<EOF
  #!/bin/bash  
  sudo wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/el/8/chef-workstation-21.10.640-1.el8.x86_64.rpm
  sudo yum localinstall chef-workstation-21.10.640-1.el8.x86_64.rpm
  sudo chef -v
EOF
  tags = {
    Name = "TEST"
    role = "web"
  }
}
