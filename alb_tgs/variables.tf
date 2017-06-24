variable "stack_name" {
   default="jasonxue"
   description = "Stack name to separate different resources"
}
variable "name" {
   default="jasonxue"
   description = "ALB name for different services"
}
variable "environment" {
    default="test"
    description = "Environment tag, e.g prod"
}

variable "alb_subnet_ids" {
  description = "list of subnets where ALB should be deployed"
  type = "list"
}

variable "alb_sgs"{
  description = "list of security groups where ALB should be deployed"
  type = "list"
}
variable "alb_tg_names"{
  description = "list of target groups names"
  type = "list"
}
variable "alb_tg_protocals"{
  description = "list of target groups protocals"
  type = "list"
}

variable "alb_listener_port" {
    default= "80"
    description = "The port for user access"
}
variable "alb_rule_paths" {
  description = "list of listener rules based on paths"
  type = "list"
}

variable "vpc_id" {
  description = "Id of VPC where ALB will live"
}
