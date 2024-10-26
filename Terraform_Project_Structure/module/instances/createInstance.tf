# Create Instance usng Custom VPC
#Resource key pair
resource "aws_key_pair" "levelup_key" {
  key_name                        = "levelup_key"
  public_key                      = file(var.public_key_path) # this is reading the file from the variable public_key_path
}

#security group for instances
resource "aws_security_group" "allow-ssh" {
  vpc_id                         = var.VPC_ID
  name                           = "allow-ssh-${var.ENVIRONMENT}"
  description                    = "security group that allows ssh traffic"

  egress {
    from_port                    = 0
    to_port                      = 0
    protocol                     = "-1" 
    cidr_blocks                  = ["0.0.0.0/0"]   
  } 

  ingress {
    from_port                    = 22
    to_port                      = 22
    protocol                     = "tcp" 
    cidr_blocks                  = ["0.0.0.0/0"]   
  } 

  tags = {
    Name                        = "allow-ssh"
    Environment                 = var.ENVIRONMENT
  }
}

#Create Instance Group
resource "aws_instance" "my-instance" {
  ami           = lookup(var.AMIS, var.AWS_REGION) #we are taking the ami from the variable AMIS on the basis of the aws region. for the lookup function its a map and a key
  instance_type = var.INSTANCE_TYPE

  # the VPC subnet
  subnet_id = element(var.PUBLIC_SUBNETS, 0)
  availability_zone = "${var.AWS_REGION}a"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # the public SSH key
  key_name = aws_key_pair.levelup_key.key_name

  tags = {
    Name         = "instance-${var.ENVIRONMENT}"
    Environmnent = var.ENVIRONMENT
  }
}
