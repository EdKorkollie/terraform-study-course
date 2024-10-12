resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "myFirstInstance" {
  ami = lookup(var.AMIS, var.AWS_REGION)
  availability_zone = "us-east-1a"
  key_name = aws_key_pair.levelup_key.key_name

  instance_type = "t2.micro"

  tags = {
    Name = "custome_instance"
  }
}

# EBS resource creating
resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "us-east-1a"
  size = 50
  type = "gp2"

  tags = {
    Name = "Secondary volume Disk"
  }
}

#Attach EBS volume with AWS instance
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.myFirstInstance.id
}
/*
After creating the instance you have to run some commands to fully attach the volume
ssh to your instance, run command df -h to see the available disk. you will see your disk 
/dev/xvdh is not yet available. until your create the file system on your machine and mount
it you will not see your disk.
create file system: mkfs .ext4 /dev/xvdh
mount the disk: mkdir -p /data
mount /dev/xvdh /data
to avoid lossing your disk after reboot
mkdir -p /data
mount /dev/xvdh /data
open vim /etc/fstab and the following line: /dev/xvdh /data ext4 defaults 0 0
this will help aviod losing the disk after instance reboot
After attaching the disk: cd /data and create ro add some file then reboot the machine again
the data will still be present after the machine is rebooted
What happen to the disk after the intance is Terminated?
the data will still be present
*/