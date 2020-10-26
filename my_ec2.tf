/*
This code will do the following.
- use aws provider
- Create an EC2 instance with specific AMI id.
- use user_data to do some post provisioning tasks.
- create a security group to allow traffic to port 8080
- use variable to specify the port.
- Create a relationship between aws_instance and security group..
- use Tags on the EC2 instance.
- use the output block to get the public ip of the created EC2 instance.
*/

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami                    = "ami-042b34111b1289ccd"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    Name = "TF_Practise"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

variable "server_port" {
  description = "The port will be used for HTTP requests"
  type        = number
  default     = 8080
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the web server that we create"
}
