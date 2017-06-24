/**
 * The ECR module aims to create a elastic container registry when needed
 *
 * Usage:
 *
 *    module "m_ecrs" {
 *      source      = "github.com/soldierxue/terraformlib/ecrs"
 *      name        = "my-repo"
 *    }
 *
 */

variable names {
   default =["ecr-repo"]
   type = "list"
}

resource "aws_ecr_repository" "ecr_regs" {
  count = "${length(var.names)}"
  name = "${element(var.names, count.index)}"
}


output ecr_repo_urls {
  value = ["${aws_ecr_repository.ecr_regs.*.repository_url}"]
}

output ecr_names {
  value = ["${aws_ecr_repository.ecr_regs.*.name}"]
}

output ecr_arns {
  value = ["${aws_ecr_repository.ecr_reg.*.arn}"]
}