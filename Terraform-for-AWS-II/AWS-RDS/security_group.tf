resource "aws_security_group" "allow-levelup-ssh" {
    vpc_id = aws_vpc.levelup_vpc.id
    name = "allow-levelup-ssh"
    description = "secirity group that allows ssh connectio"

    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1" # means all protocol
        cidr_blocks = ["0.0.0.0/0"] # means all port
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      Name = "allow-levelup-ssh"
    }
}

#security group for MariaDB
resource "aws_security_group" "allow-mariadb" {
    vpc_id = aws_vpc.levelup_vpc.id
    name = "allow-mariaDB"
    description = "secirity group that allows Maria DB"

    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1" # means all protocol
        cidr_blocks = ["0.0.0.0/0"] # means all port
    }

    ingress {
        from_port = 3306 # port for MariaDB
        to_port =3306
        protocol = "tcp"
        security_groups = [aws_security_group.allow-levelup-ssh.id] # this list the SG of the AWS instances which will be allow to access the maria DB
    }

    tags = {
      Name = "allow-levelup-MariaDB"
    }
}