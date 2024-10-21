#AutoScaling Launch configuration
resource "aws_launch_configuration" "levelup-launchConfig" {
  name_prefix      = "levelup-launchConfig"
  image_id         =  lookup(var.AMIS, var.AWS_REGION)
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.levelup_key.key_name 
  security_groups = [aws_security_group.levelup-instance.id]
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"

  lifecycle {
    create_before_destroy = true  # whenever it creates an instance, it will destroy it if the instance already exist
  }
}

#Generate key
resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling group
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                           = "levelup-autoscalin"                                       # name of the autoscaling 
  vpc_zone_identifier            = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id]          # in which zone the instance can be launch or created
  launch_configuration           = aws_launch_configuration.levelup-launchConfig.name
  min_size                       = 2
  max_size                       = 2
  health_check_grace_period      = 200                                                        #means after 200 seconds of health check failure a new instance will be created
  health_check_type              = "ELB"     #health check will be done by the ELB
  load_balancers                 = [aws_elb.levelup-elb.name]       #assign the loadbalancer to the aws autoscaling group
  force_delete                   = true

  tag {
    key                          = "Name"
    value                        = "Levleup Custom EC2 instance via lb"
    propagate_at_launch          = true  
  }  
}

output "ELB" {
  value                          = aws_elb.levelup-elb.dns_name             #this will print the endpoint of your elb
}