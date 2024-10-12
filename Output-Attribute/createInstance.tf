data "aws_availability_zones" "available" {} # this will search all the AWS Availability zones and store it in this  variable

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}

resource "aws_instance" "myFirstInstance" {
  ami               = data.aws_ami.latest_ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = data.aws_availability_zones.available.names[1]

  provisioner "local-exec" {
    command = "echo aws_instance.myFirstInstance.private_ip >> my_private_ips.txt" # copy the private ip in a file

  }

  tags = {
    name = "custom_instance"
  }

}

output "public_ip" {
  value = aws_instance.myFirstInstance.public_ip
}

