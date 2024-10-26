# the purpose of this file is to create the resources for the dev env

# Create Resource for Development Environment

#this module will create the vpc
module "dev-vpc" {
    source      = "../module/vpc" # path of the directory where we have the vpc. inside the module directory we have the vpc

#these are the two variables which was required inside of the vpc module
    ENVIRONMENT = var.Env
    AWS_REGION  = var.AWS_REGION
}

#this module will create the instances
module "dev-instances" {
    source          = "../module/instances"

    ENVIRONMENT     = var.Env
    AWS_REGION      = var.AWS_REGION 
    VPC_ID          = module.dev-vpc.my_vpc_id  #we are reading the vpc value from the module we created above and using the ouput variable for the vpc
    PUBLIC_SUBNETS  = module.dev-vpc.public_subnets
}

provider "aws" {
  region = var.AWS_REGION
}