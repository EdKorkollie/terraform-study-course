provider "aws" {
  region = var.AWS_REGION
}

module "ec2_luster" {
   source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git" 

   name = "my-cluster"
   ami = "ami-053053586808c3e70"
   instance_type = "t2.micro"
   subnet_id = "subnet-004685addee3e9660"
   # = var.environment == "production" ? 2 : 1   #if the environment equals production we need to spin up 2 instances, otherwise spin up 1 instance

   tags = {
      Terraform = "true"
      Environment = var.environment
   }

   
  
}