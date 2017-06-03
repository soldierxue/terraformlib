output "php-public-url" {
  value = "${aws_instance.phpapp.public_dns}"
}
output "php-public-url-dbcall" {
  value = "${aws_instance.phpapp.public_dns}/calldb.php"
}
output "php-ec2-keyname" {
  value = "${var.ec2keyname}"
}