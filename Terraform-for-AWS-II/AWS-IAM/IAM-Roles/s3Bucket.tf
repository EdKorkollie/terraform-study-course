#Create AWS S3 Bucket
resource "aws_s3_bucket" "boaye-s3bucket" {
  bucket = "boaye-s3bucket-01" #Bucket name: bucket name must be globally unique
  acl = "private"

  tags = {
    Name = "boaye-s3bucket-01"
  }
}