data "aws_region" "current" {
  current = true
}
variable "service_name" {
  description = "Name of service"
}
variable "family_name" {
  description = "Family Name of task"
}

variable "docker_image" {
  description = "Docker image to run"
}

variable "docker_tag" {
  description = "Tag of docker image to run"
}

variable "container_cpu" {
  description = "The number of cpu units to reserve for the container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
}

variable "container_memory" {
  description = "The number of MiB of memory to reserve for the container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
}

variable "container_port" {
  description = "Port that service will listen on"
}

variable "cluster_name" {
  description = "Name of ECS cluster"
}

variable "desired_count" {
  description = "Initial number of containers to run"
}

variable "ecs_service_role_arn" {
  description = "ARN of IAM role for ECS service"
}

variable "target_group_arn" {
  description = "ARN of ALB target group for service"
}

variable "spring_profile_active" {
  description = "the active profile name for spring cloud application"
  default = "ecs"
}