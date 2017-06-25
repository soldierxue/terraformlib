variable vpc_id {
  description = "id of the to be associated vpc"
}
variable dns_zone_name  {
  description = "name for route53 host zone"
}

variable dns_cname_records  {
  description = "records  for route53 cnames"
  type = "list"
  default = []
}
variable dns_a_records  {
  description = "records  for route53 a records"
  type = "list"
  default = []
}

variable dns_names {
  description = "name list for route53 records"
  type = "list"
  default = []
}

resource "aws_route53_zone" "primary" {
  name = "${var.dns_zone_name}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_route53_record" "cnames" {
  count = "${length(var.dns_a_records) == 0 ? length(var.dns_names) : 0}"
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "${element(var.dns_names,count.index)}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${element(var.dns_cname_records,count.index)}"]
}

resource "aws_route53_record" "arecords" {
  #count = "${length(var.dns_cname_records) == 0 ? length(var.dns_names) : 0}"
  count = "${length(var.dns_a_records)}"
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "${element(var.dns_names,count.index)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(var.dns_a_records,count.index)}"]
}

#####
resource "aws_vpc_dhcp_options" "mydhcp" {
    domain_name = "${var.dns_zone_name}"
    domain_name_servers = ["AmazonProvidedDNS"]
    tags {
      Name = "Submit DEMO DHCP Internal"
      Owner = "Jason"
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${var.vpc_id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.mydhcp.id}"
}