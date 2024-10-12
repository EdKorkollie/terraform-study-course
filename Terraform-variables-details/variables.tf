variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "security_group" {
  type    = list(string)
  default = ["sg-24076", "sg-449569", "sg-354786568"]

}

variable "AMIS" {
  type = map(string)
  default = {
    "us-east-1" = "ami-053053586808c3e70"
    "us-east-2" = "ami-068cf3d51efeb20d6"
    "us-west-2" = "ami-0a5d7c68997d6ab3a"
    "us-west-1" = "ami-082ebbea44fc7abcd"
  }

}

variable "PATH_TO_PRIVATE_KEY" {
  default = "levelup_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "levelup_key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
