resource "aws_kms_key" "s3_kms_key" {
  description             = "S3 KMS Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags {
    Name         = "${var.environment}-aws-s3"
    environmet   = "${var.environment}"
    location     = "aws"
    role         = "${var.role}"
    service      = "${var.service}"
    owner        = "${var.owners}"
  } 
}

resource "aws_kms_alias" "s3_kms_key_alias" {
  name          = "alias/${var.environment}-aws-s3"
  target_key_id = "${aws_kms_key.s3_kms_key.key_id}"
}

resource "aws_kms_key" "rds_kms_key" {
  description             = "RDS KMS Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags {
    Name         = "${var.environment}-aws-rds"
    environmet   = "${var.environment}"
    location     = "aws"
    role         = "${var.role}"
    service      = "${var.service}"
    owner        = "${var.owners}"
  } 
}

resource "aws_kms_alias" "rds_kms_key_alias" {
  name          = "alias/${var.environment}-aws-rds"
  target_key_id = "${aws_kms_key.rds_kms_key.key_id}"
}

resource "aws_kms_key" "ebs_kms_key" {
  description             = "EBS KMS Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags {
    Name         = "${var.environment}-aws-ebs"
    environmet   = "${var.environment}"
    location     = "aws"
    role         = "${var.role}"
    service      = "${var.service}"
    owner        = "${var.owners}"
  } 
}

resource "aws_kms_alias" "ebs_kms_key_alias" {
  name          = "alias/${var.environment}-aws-ebs"
  target_key_id = "${aws_kms_key.ebs_kms_key.key_id}"
}

resource "aws_kms_key" "redshift_kms_key" {
  description             = "Redshift KMS Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags {
    Name         = "${var.environment}-aws-redshift"
    environmet   = "${var.environment}"
    location     = "aws"
    role         = "${var.role}"
    service      = "${var.service}"
    owner        = "${var.owners}"
  } 
}

resource "aws_kms_alias" "redshift_kms_key_alias" {
  name          = "alias/${var.environment}-aws-redshift"
  target_key_id = "${aws_kms_key.redshift_kms_key.key_id}"
}