output "instances" {
  value = ["${aws_instance.nat.*.id}"]
}

output "ips" {
  value = ["${aws_eip.eip.*.public_ip}"]
}

output "remote_exec" {
  value = ["${null_resource.provision.*.remote-exec}"]
}