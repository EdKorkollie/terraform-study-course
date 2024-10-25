resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Create Instance
resource "aws_instance" "myFirstInstance" {
  ami = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = aws_key_pair.levelup_key.key_name

  #in order for the instance to identify our IAM role that we have create, we use the iam instance profile.
  iam_instance_profile = aws_iam_instance_profile.s3-boayebucket-role-instanceprofile.name
  tags = {
    Name = "custome_instance"
  }
}

output "public_ip" {
  value = aws_instance.myFirstInstance
}

# run ssh-keygen -f levelup-key to generate public and private key

/*
  ssh to instance: ssh publicIP -l ubuntu -i keypairName
  after you have create your instance, login to your machine to test the s3 bucket role
  sudo -i
  apt-get update
  create some content in your s3 bucket from your instance
  we need aws cli, we need to install python to install aws cli
  apt-get install python-pip python-dev
  pip install awscli
  ls
  echo "first now from TF class" > firstfile.txt
  upload this file to s3 bucket which you have create
  aws s3 cp firstfile.txt s3://nameOFs3Bucket

*/

