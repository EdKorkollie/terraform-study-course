data "aws_ip_ranges" "us_east_ip_range" {
  regions  = ["us-east-1", "use-east-2"] # define the region you want the IP filter
  services = ["ec2"]                     # define the service on which you want the IP filter
}

resource "aws_security_group" "sg-custom_us_east" {
  name = "SG-custom_us_east"

  # Define inbound rule
  ingress {
    from_port   = "443" # define from which port you want to accept traffic
    to_port     = "443" # define to which port you want to send traffic
    protocol    = "tcp"
    cidr_blocks = data.aws_ip_ranges.us_east_ip_range.cidr_blocks
  }

  tags = {
    createDate = data.aws_ip_ranges.us_east_ip_range.create_date # Defines the create date for the SG
    syncToken  = data.aws_ip_ranges.us_east_ip_range.sync_token
  }


}
