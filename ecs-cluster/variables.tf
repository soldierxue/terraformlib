variable "stack_name" {
   default="jasonxue"
   description = "Name tag for resources"
}
variable "environment" {
    default="test"
    description = "Environment tag, e.g prod"
}

variable "cluster_name" {
  description = "Name of ECS cluster"
  default = "ecs-cluster"
}

variable "instance_type" {
  description = "Instance type of each EC2 instance in the ECS cluster"
  default = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster"
}

variable "asg_min" {
  description = "Minimum number of EC2 instances to run in the ECS cluster"
  default = "2"
}

variable "asg_max" {
  description = "Maximum number of EC2 instances to run in the ECS cluster"
  default = "4"
}

variable "asg_desired_size" {
  description = "Desired number of EC2 instances to run in the ECS cluster"
  default = "2"
}

variable "security_group_ecs_instance_id" {
  description = "Id of security group allowing internal traffic"
}

variable "ecs_cluster_subnet_ids" {
  description = " List of subnets where EC2 instances should be deployed"
  type = "list"
}

variable "target_group_arn" {
  default = "ALB Target group ARN"
}

data "aws_ami" "ecs_optimized_ami" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-*amazon-ecs-optimized"]
  }

  owners     = ["amazon"]
}