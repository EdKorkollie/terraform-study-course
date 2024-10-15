resource "aws_instance" "myFirstInstance" {
    count             = 3 # number of instance you want to create
    ami               = "ami-053053586808c3e70" #https://cloud-images.ubuntu.com/locator/ec2/, you can get your ami from this website
    instance_type = "t2.micro"

    tags= {
        name = "threedemoinstance-${count.index}" # to distinquish the name of the instances
    }
}

