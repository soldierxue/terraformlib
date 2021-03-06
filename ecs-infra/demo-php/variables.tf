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
    values = ["amzn-ami-hvm*2017*x86_64*ebs*"]
  }

  owners     = ["amazon"]
}


###
### Demo: PHPAPP(public subnet) + MySQL(private subnet)
###
variable "DnsZoneName" {
  default = "jasondemo.internal"
  description = "the internal dns name"
}

variable "mysqlPrefix" {
  default = "mysqldb"
  description = "the prefix name for mysql server"
}