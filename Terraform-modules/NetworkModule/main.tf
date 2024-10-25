/*
in this main.tf file, we will define the source code which will help us to spin up the resources,
which will use the module VPC network
*/
#Provider
provider "aws" {
	region = var.region # we will get the region at runtime
}

#Which Module i want to use
module "myvpc" {
    source = "./module/network"  #module location is ./= current directory, then module then network = ./module/network. main.tf is present at the current directory
}

#Resource key pair
resource "aws_key_pair" "levelup_key" {
  key_name      = "levelup_key"
  public_key    = file(var.public_key_path)
}

#EC2 Instance
resource "aws_instance" "levelup_instance" {
  ami                       = var.instance_ami
  instance_type             = var.instance_type
  subnet_id                 = module.myvpc.public_subnet_id
  vpc_security_group_ids    = module.myvpc.sg_22_id
  key_name                  = aws_key_pair.levelup_key.key_name

  tags = {
		Environment         = var.environment_tag
	}
}