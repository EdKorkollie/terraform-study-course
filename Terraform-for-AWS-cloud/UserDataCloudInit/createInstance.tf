resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "myFirstInstance" {
  ami = lookup(var.AMIS, var.AWS_REGION)
  availability_zone = "us-east-1a"
  key_name = aws_key_pair.levelup_key.key_name

  instance_type = "t2.micro"

  user_data =data.template_cloudinit_config.install-apache-config.rendered

  tags = {
    Name = "custome_instance"
  }
}

output "public_ip" {
  value = aws_instance.myFirstInstance
}

