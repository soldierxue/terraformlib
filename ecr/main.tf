/**
 * The ECR module aims to create a elastic container registry when needed
 *
 * Usage:
 *
 *    module "m_ecr" {
 *      source      = "github.com/soldierxue/terraformlib/ecr"
 *      name        = "my-repo"
 *    }
 *
 */

variable name {
   default ="ecr-repo"
}

resource "aws_ecr_repository" "ecr_reg" {
  name = "${var.name}"
}


output ecr_repo_url {
  value = "${aws_ecr_repository.ecr_reg.repository_url}"
}

output ecr_name {
  value = "${aws_ecr_repository.ecr_reg.name}"
}

output ecr_arn {
  value = "${aws_ecr_repository.ecr_reg.arn}"
}