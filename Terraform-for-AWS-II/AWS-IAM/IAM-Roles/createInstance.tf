resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Create Instance
resource "aws_instance" "myFirstInstance" {
  ami = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = aws_key_pair.levelup_key.key_name

  #in order for the instance to identify our IAM role that we have create, we use the iam instance profile.
  iam_instance_profile = aws_iam_instance_profile.s3-boayebucket-role-instanceprofile.name
  tags = {
    Name = "custome_instance"
  }
}

output "public_ip" {
  value = aws_instance.myFirstInstance
}

