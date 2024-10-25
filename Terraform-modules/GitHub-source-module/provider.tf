provider "aws" {
  region = "us-east-1"
}

/*

you can export your secret key on the command line like this export AWS_SECRET_KEY="write secret key here" for unix shell. to verify: echo $AWS_SECRET_KEY
for windows use command: $env:AWS_SECRET_KEY="write secret key here". to verify:$env:AWS_SECRET_KEY
*/