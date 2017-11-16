resource "aws_cloudwatch_log_group" "spring_hw_service_lg" {
  name = "${var.service_name}"
}

data "template_file" "task_definition" {
  template = "${file("${path.module}/hw-spring-task.json")}"

  vars {
    service_name = "${var.service_name}"
    family_name = "${var.family_name}"
    docker_image = "${var.docker_image}"
    docker_tag = "${var.docker_tag}"
    container_cpu = "${var.container_cpu}"
    container_memory = "${var.container_memory}"
    container_port = "${var.container_port}"
    log_group_name = "${aws_cloudwatch_log_group.spring_hw_service_lg.name}"
    log_group_region = "${data.aws_region.current.name}"
    spring_profile_active = "${var.spring_profile_active}"
  }
}

# The ECS task that specifies what Docker containers we need to run the service
resource "aws_ecs_task_definition" "spring_hw_service" {
  family = "${var.family_name}"
  container_definitions = "${data.template_file.task_definition.rendered}"
}

# A long-running ECS service for the spring_hw_service task
resource "aws_ecs_service" "spring_hw_service" {
  count = "${var.pc_memberOfCount == 0 && var.pc_distinctInstanceCount== 0 ? 1 : 0}"
  name = "${var.service_name}"
  cluster = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.spring_hw_service.arn}"
  desired_count = "${var.desired_count}"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  iam_role = "${var.ecs_service_role_arn}"

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "${var.service_name}"
    container_port = "${var.container_port}"
  }
  placement_strategy {
    type  = "${var.ps_type}"
    field = "${var.ps_field}"
  }
}

resource "aws_ecs_service" "spring_hw_service_with_pc_memberof" {
  count = "${var.pc_memberOfCount}"
  
  name = "${var.service_name}"
  cluster = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.spring_hw_service.arn}"
  desired_count = "${var.desired_count}"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  iam_role = "${var.ecs_service_role_arn}"

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "${var.service_name}"
    container_port = "${var.container_port}"
  }
  placement_strategy {
    type  = "${var.ps_type}"
    field = "${var.ps_field}"
  }  
  placement_constraints {
    type       = "memberOf"
    expression = "${var.pc_memberOf_expression}"
  }
}

resource "aws_ecs_service" "spring_hw_service_with_pc_distinctinstance" {
  count = "${var.pc_distinctInstanceCount}"
  
  name = "${var.service_name}"
  cluster = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.spring_hw_service.arn}"
  desired_count = "${var.desired_count}"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  iam_role = "${var.ecs_service_role_arn}"

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "${var.service_name}"
    container_port = "${var.container_port}"
  }
  placement_strategy {
    type  = "${var.ps_type}"
    field = "${var.ps_field}"
  }  
  placement_constraints {
    type       = "distinctInstance"
  }  
}
