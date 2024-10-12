resource "aws_instance" "myFirstInstance" {
    count             = 3
    ami               = "ami-053053586808c3e70"
    instance_type = "t2.micro"

    tags= {
        name = "threedemoinstance-${count.index}" # to distinquish the name of the instances
    }
}

