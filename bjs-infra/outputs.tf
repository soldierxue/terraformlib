output region {
  value = "${var.region}"
}
output stack_name {
  value = "${var.stack_name}"
}
output environment {
  value = "${var.environment}"
}
output vpc_id {
  value = "${module.aws-vpc.vpc_id}"
}

output subnet_private_ids {
  value = "${module.aws-vpc.subnet_private_ids}"
}

output subnet_public_ids {
  value = "${module.aws-vpc.subnet_public_ids}"
}

output private_route_ids {
  value = "${module.aws-vpc.private_route_ids}"
}

output base_cidr_block {
  value = "${var.base_cidr_block}"
}

output sg_database_id {
  value = "${module.securities.sg_database_id}"
}

output sg_frontend_id {
  value = "${module.securities.sg_frontend_id}"
}

output sg_internal_id {
  value = "${module.securities.sg_internal_id}"
}
