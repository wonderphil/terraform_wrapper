provider "aws" {
  region              = "${var.aws_region}"
  profile             = "${var.aws_profile}"
  allowed_account_ids = ["${var.aws_account_id}"]
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "aws_accounts" {
  workspace = "${var.environment}-${var.remote_state_region}"
  backend   = "${var.remote_state_backend}"

  config {
    bucket     = "${var.remote_state_bucket}"
    key        = "${var.remote_state_aws_accounts_key}"
    region     = "${var.remote_state_region}"
    kms_key_id = "${var.remote_state_s3_kms_key}"
    profile    = "${var.remote_state_profile}"
  }
}

data "aws_availability_zones" "all" {}
