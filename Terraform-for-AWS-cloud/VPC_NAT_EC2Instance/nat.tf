#Define External IP
resource "aws_eip" "levelup-nat" {
  vpc = true
}

#public subnet dependency with intenet gateway
resource "aws_nat_gateway" "levelup-nat-gw" {
    allocation_id = aws_eip.levelup-nat.id
    subnet_id = aws_subnet.levelupvpc-public-1.id
    depends_on = [ aws_internet_gateway.levelup-gw]
}

#vpc for the nat gw so that outer machine cannot access my machine. but your machine can access the other machine outside of the network
resource "aws_route_table" "levelup-private" {
    vpc_id = aws_vpc.levelup_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.levelup-nat-gw.id
    }

    tags = {
        Name = "levelup-private"
    }
}

# Route table association private
resource "aws_route_table_association" "levelup-private-1-a" {
    subnet_id = aws_subnet.levelupvpc-private-1.id
    route_table_id = aws_route_table.levelup-private.id
  
}

# Route table association private
resource "aws_route_table_association" "levelup-private-1-b" {
    subnet_id = aws_subnet.levelupvpc-private-2.id
    route_table_id = aws_route_table.levelup-private.id
  
}

# Route table association private
resource "aws_route_table_association" "levelup-private-1-c" {
    subnet_id = aws_subnet.levelupvpc-private-3.id
    route_table_id = aws_route_table.levelup-private.id
  
}