#TF file for IAM users and groups

#iam user one
resource "aws_iam_user" "adminuser1" {
  name = "adminuser1"
}

#iam user two
resource "aws_iam_user" "adminuser2" {
  name = "adminuser2"
}

#Group definition
resource "aws_iam_group" "adminGroup" {
  name = "adminGroup"
}

#Assign users to AWS Group
resource "aws_iam_group_membership" "admin-users" {
  name = "admin-users"

  #list of users you want to assign to a group
  users = [ 
    aws_iam_user.adminuser1.name,
    aws_iam_user.adminuser2.name,
   ]

   #in which group you want to assign the users
   group = aws_iam_group.adminGroup.name
}

#Policy for AWS Group
resource "aws_iam_policy_attachment" "admin-users-attach" {
  name = "admin-users-attach"
  groups = [ aws_iam_group.adminGroup.name ] #List of group the policy will be attached to
  policy_arn = "arn:aws:iam:aws:policy/AdministractorAccess" #means im giving this group administractive access
}

#Note: if you create adminstractoraccess policy, if you use terraform destroy, it might impact your account so refrain from using terraform destroy after you create this policy.
