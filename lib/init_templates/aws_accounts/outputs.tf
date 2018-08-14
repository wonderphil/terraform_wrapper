output "terraform_dynamodb_table_arn" {
  value = "${module.aws_account.terraform_dynamodb_table_arn}"
}

output "terraform_dynamodb_table_id" {
  value = "${module.aws_account.terraform_dynamodb_table_id}"
}

#kms
output "s3_kms_arn" {
  value = "${module.aws_account.s3_kms_arn}"
}

output "s3_kms_key_id" {
  value = "${module.aws_account.s3_kms_id}"
}

output "s3_kms_key_alias" {
  value = "${module.aws_account.s3_kms_alias}"
}

output "rds_kms_arn" {
  value = "${module.aws_account.rds_kms_arn}"
}

output "rds_kms_key_id" {
  value = "${module.aws_account.rds_kms_id}"
}

output "rds_kms_key_alias" {
  value = "${module.aws_account.rds_kms_alias}"
}

output "ebs_kms_arn" {
  value = "${module.aws_account.ebs_kms_arn}"
}

output "ebs_kms_key_id" {
  value = "${module.aws_account.ebs_kms_id}"
}

output "ebs_kms_key_alias" {
  value = "${module.aws_account.ebs_kms_alias}"
}

#s3
output "s3_terraform_state_id" {
  value = "${module.aws_account.s3_terraform_state_id}"
}

output "s3_terraform_state_arn" {
  value = "${module.aws_account.s3_terraform_state_arn}"
}

output "s3_terraform_state_region" {
  value = "${module.aws_account.s3_terraform_state_region}"
}