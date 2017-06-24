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
}

resource "aws_route53_zone" "primary" {
  name = "${var.dns_zone_name}"
}

resource "aws_route53_record" "cnames" {
  count = "${length(var.dns_cname_records)}"
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "${element(var.dns_names,count.index)}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${element(var.dns_cname_records,count.index)}"]
}

resource "aws_route53_record" "arecords" {
  count = "${length(var.dns_a_records)}"
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "${element(var.dns_cnames,count.index)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(var.dns_a_records,count.index)}"]
}