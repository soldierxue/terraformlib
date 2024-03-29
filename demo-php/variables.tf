variable "name" {
   default="jasonxue"
   description = "Stack name to separate different resources"
}
variable "environment" {
    default="test"
    description = "Environment tag, e.g prod"
}

variable vpc_id {}
variable public_subnet_id{}
variable fronend_web_sgid{}
variable private_subnet_id{}
variable database_sgid{}
variable ec2keyname{}


data "aws_ami" "amazonlinux_ami" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*2021*x86_64*ebs*"]
  }

  owners     = ["amazon"]
}

