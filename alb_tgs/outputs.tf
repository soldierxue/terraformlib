output "alb_public_url" {
  value = "${aws_alb.dmz-alb.dns_name}:${aws_alb_listener.instance_listener.port}"
}
output "alb_public_url_withoutport" {
  value = "${aws_alb.dmz-alb.dns_name}"
}

output "alb_listener_arn" {
  value = "${aws_alb_listener.instance_listener.arn}"
}

output "target_group_arns" {
  value = ["${aws_alb_target_group.instance_tg.*.arn}"]
}