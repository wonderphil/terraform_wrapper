#dynamodb.tf
output "terraform_dynamodb_table_arn" {
  value = ["${aws_dynamodb_table.terraform_dynamodb_table.*.arn}"]
}

output "terraform_dynamodb_table_id" {
  value = ["${aws_dynamodb_table.terraform_dynamodb_table.*.id}"]
}

#kms.tf
output "s3_kms_arn" {
  value = "${aws_kms_key.s3_kms_key.arn}"
}

output "s3_kms_id" {
  value = "${aws_kms_key.s3_kms_key.key_id}"
}

output "s3_kms_alias" {
  value = "${aws_kms_alias.s3_kms_key_alias.name}"
}

output "rds_kms_arn" {
  value = "${aws_kms_key.rds_kms_key.arn}"
}

output "rds_kms_id" {
  value = "${aws_kms_key.rds_kms_key.key_id}"
}

output "rds_kms_alias" {
  value = "${aws_kms_alias.rds_kms_key_alias.name}"
}

output "ebs_kms_arn" {
  value = "${aws_kms_key.ebs_kms_key.arn}"
}

output "ebs_kms_id" {
  value = "${aws_kms_key.ebs_kms_key.key_id}"
}

output "ebs_kms_alias" {
  value = "${aws_kms_alias.ebs_kms_key_alias.name}"
}

output "redshift_kms_arn" {
  value = "${aws_kms_key.redshift_kms_key.arn}"
}

output "redshift_kms_id" {
  value = "${aws_kms_key.redshift_kms_key.key_id}"
}

output "redshift_kms_alias" {
  value = "${aws_kms_alias.redshift_kms_key_alias.name}"
}

#s3.tf
output "s3_terraform_state_id" {
  value = "${module.aws_s3_terraform_state.kms_s3_bucket_id}"
}

output "s3_terraform_state_arn" {
  value = "${module.aws_s3_terraform_state.kms_s3_bucket_arn}"
}

output "s3_terraform_state_region" {
  value = "${module.aws_s3_terraform_state.kms_s3_bucket_region}"
}
