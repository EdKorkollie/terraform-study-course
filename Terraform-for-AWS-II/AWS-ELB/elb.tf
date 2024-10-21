#AWS ELB configuration
resource "aws_elb" "levelup-elb" {
  name                         = "levelup-elb"
  subnets                      = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id]
  security_groups              = [aws_security_group.levelup-elb-securitygroup.id]

  # this means the loadbalancer (lb)  and the instance will send and receive traffic on port 80 and protocol is http
  listener {
    instance_port              = 80
    instance_protocol          = "http"
    lb_port                    = 80
    lb_protocol                = "http"     
  }
  health_check {
    healthy_threshold          = 2      #it will mark healthy after 2 consecutive success
    unhealthy_threshold        = 2      #it will mark unhealthy after 2 consecutive failures
    timeout                    = 3
    target                     = "HTTP:80/"
    interval                   = 30         #it means after every 30sec this health check will trigger on port 80 via http   
  }

  cross_zone_load_balancing    = true
  connection_draining          = true
  connection_draining_timeout  = 400
  tags = {
    Name                       = "levelup-elb"
  }  
}

#Security group for AWS ELB
resource "aws_security_group" "levelup-elb-securitygroup" {
  vpc_id                      = aws_vpc.levelup_vpc.id
  name                        = "levelup-elb-sg"
  description                 = "security group for Elastic load balancer"

  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  } 

  ingress {
    from_port                 = 80
    to_port                   = 80
    protocol                  = "tcp"
    cidr_blocks               = ["0.0.0.0/0"]
  } 

  tags = {
    Name                      = "levelup-elb-sg"
  }
}

#Security group for instances
resource "aws_security_group" "levelup-instance" {
  vpc_id                      = aws_vpc.levelup_vpc.id
  name                        = "levelup-instance"
  description                 = "security group for instances"

  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  } 

  #ingress for ssh connection
  ingress {
    from_port                 = 22
    to_port                   = 22
    protocol                  = "tcp"
    cidr_blocks               = ["0.0.0.0/0"]
  } 

  #ingress for the connection from the elb
  ingress {
    from_port                 = 80
    to_port                   = 80
    protocol                  = "tcp"
    security_groups           = [aws_security_group.levelup-elb-securitygroup.id]   #only the elb can connect to your instance on port 80.
  } 

  tags = {
    Name                      = "levelup-instance"
  }
}