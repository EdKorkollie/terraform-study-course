resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "myFirstInstance" {
    ami               = lookup(var.AMIS, var.AWS_REGION) // lookup function will search the value of AWS region inside the variable AMIS
    instance_type = "t2.micro"
    key_name = aws_key_pair.levelup_key.key_name

    tags= {
        name= "custom_instance"
    }

    provisioner "file" {
        source = "installNginx.sh"
        destination = "/tmp/installNginx.sh"
    }

    #commands that will be used to execute the installNginx.sh file
    provisioner "remote-exec" {
      inline = [  
        "chmod +x /tmp/installNginx.sh", # provide the executable permission to this file
        "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh", # Remove the spurious CR characters
        "sudo /tmp/installNginx.sh"
      ]
    }

    connection {
      host = coalesce(self.public_ip, self.private_ip)
      type = "ssh"
      user = var.INSTANCE_USERNAME
      private_key = file(var.PATH_TO_PRIVATE_KEY)
    }
}

