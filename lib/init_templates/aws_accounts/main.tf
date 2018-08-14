provider "aws" {
  region              = "${var.aws_region}"
  profile             = "${var.aws_profile}"
  allowed_account_ids = ["${var.aws_account_id}"]
}

data "aws_availability_zones" "all" {}

module "aws_account" {
  source = "../../modules/aws_account"

  environment        = "${var.environment}"
  role               = "${var.role}"
  service            = "${var.service}"
  owners             = "${var.owners}"
  aws_region         = "${var.aws_region}"
  is_prod            = "${var.is_prod}"
}