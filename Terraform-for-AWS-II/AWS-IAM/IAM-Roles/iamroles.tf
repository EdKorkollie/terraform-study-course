#Roles to access the AWS S3 bucket
resource "aws_iam_role" "s3-boayebucket-role" {
  name                = "s3-boayebucket-role" # Name of the role

  #attaching the policy using the keyword assume_role_policy. writing jason data in the EOF block
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Acion": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF 
}

/*
    THE version of the Policy stays the same: 2012-10-17
*/

#Policy to attach the s3 bucket role
resource "aws_iam_role_policy" "s3-boayebucket-role-policy" {
    name = "s3-boayebucket-role-policy"
    role = aws_iam_role.s3-boayebucket-role.id
    policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:*"
                ],
                "Resource": [
                    "arn:aws:s3:::boaye-s3bucket-01",
                    "arn:aws:s3:::boaye-s3bucket-01/*"
                ]
            }
        ]
    }
    EOF
}

/*
    this statement "arn:aws:s3:::boaye-s3bucket-01" means, the policy is applicable on this bucket
    this statement "arn:aws:s3:::boaye-s3bucket-01/*" means, the policy is applicable to all the content of the bucket
*/

# How do we attach this role ot the EC2 instance? for this we need the instance identifier
resource "aws_iam_instance_profile" "s3-boayebucket-role-instanceprofile" {
  name = "s3-boayebucket-role" # name of the instance profile
  role = aws_iam_role.s3-boayebucket-role.name # meaning this instance profile is attached to the IAM role "s3-boayebucket-role"
}
    
