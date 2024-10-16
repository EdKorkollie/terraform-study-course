data "aws_availability_zones" "available" {} # this will search all the AWS Availability zones and store it in this  variable (available)

data "aws_ami" "latest_ubuntu" {
  most_recent = true # it means it will fetch for the most recent ubuntu AMI
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
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
    instance_type = "t2.micro"
    availability_zone = data.aws_availability_zones.available.names[1] #means chose the availablity zone which is present at index 1

    tags= {
        name= "custom_instance"
    }
}

