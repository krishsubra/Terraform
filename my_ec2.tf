provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-042b34111b1289ccd"
  instance_type = "t2.micro"

  tags = {
    Name = "TF_Practise"
  }
}
