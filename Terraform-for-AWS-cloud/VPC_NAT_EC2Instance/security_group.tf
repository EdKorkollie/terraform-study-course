#security group for levelupVPC
resource "aws_security_group" "allow-levelup-ssh" {
  vpc_id      = aws_vpc.levelup_vpc.id
  name        = "allow-levelup-ssh"
  description = "secirity group that allows ssh connectio"

  # outbound rule
  egress {
    from_port   = 0 # means all port
    to_port     = 0 # means all port
    protocol    = "-1"          # means all protocol which are applicable in AWS. if you want you can define the list of protocol
    cidr_blocks = ["0.0.0.0/0"] # means allow traffic to all IP from your machine
  }

  #inbound rule
  ingress {
    from_port   = 22 #accepting traffic from port 22 
    to_port     = 22 # to port 22
    protocol    = "tcp" # protocol will be accepted on tcp
    cidr_blocks = ["0.0.0.0/0"] # here we are accepting traffic from all IP which is not a good practice, but you can create the list of traffic from which you want to accept traffic

    #ingress traffic should always be limited

  }

  tags = {
    Name = "allow-levelup-ssh"
  }
}
