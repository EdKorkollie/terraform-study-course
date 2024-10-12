terraform {
  backend "s3" {
    bucket = "tf-state-akom-bucket" # Bucket name in terraform
    key = "development/terraform_state" #key to separate out the project. this state file is for dev env.
    region = "us-east-1"
  }
}