# Application load balancer that distributes load between the instances
resource "aws_alb" "dmz-alb" {
  name = "${format("alb-%s-%s-%s", var.name, var.stack_name,var.environment)}"
  internal = "${var.alb_is_internal}"

  security_groups = [
    "${var.alb_sgs}"
  ]

  subnets = ["${var.alb_subnet_ids}"]
  tags {
    Name        = "${var.name}-balancer"
    Service     = "${var.name}"
    Environment = "${var.environment}"
  }
}

# Default ALB target group that defines the default port/protocol the instances will listen on
resource "aws_alb_target_group" "instance_tg" {
  count = "${length(var.alb_tg_names)}"
  name = "${element(var.alb_tg_names, count.index)}_${var.stack_name}"
  protocol = "${element(var.alb_tg_protocals, count.index)}"
  port = "32768"
  vpc_id = "${var.vpc_id}"
  
  depends_on = ["aws_alb.dmz-alb"]
}

# ALB listener that checks for connection requests from clients using the port/protocol specified
# These requests are then forwarded to one or more target groups, based on the rules defined
resource "aws_alb_listener" "instance_listener" {  
  load_balancer_arn = "${aws_alb.dmz-alb.arn}"
  port = "${var.alb_listener_port}"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${element(aws_alb_target_group.instance_tg.*.arn, 0)}"
    type = "forward"
  }

  depends_on = ["aws_alb_target_group.instance_tg"]
}

resource "aws_alb_listener_rule" "rules" {
  count = "${length(var.alb_tg_names)}"
  listener_arn = "${aws_alb_listener.instance_listener.arn}"
  priority     = "${count.index+100}"

  action {
    type             = "forward"
    target_group_arn = "${element(aws_alb_target_group.instance_tg.*.arn, count.index)}"
  }

  condition {
    field  = "path-pattern"
    values = ["/${element(var.alb_rule_paths,count.index)}/*"]
  }
}
