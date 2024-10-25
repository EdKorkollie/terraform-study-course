module "ec2_luster" {
   source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git" 

   name = "my-cluster"
   ami = "ami-053053586808c3e70"
   instance_type = "t2.micro"
   subnet_id = "subnet-004685addee3e9660"

   tags = {
      Terraform = "true"
      Environment = "dev"
   }

   
  
}

# source of this module https://github.com/terraform-aws-modules/terraform-aws-ec2-instance