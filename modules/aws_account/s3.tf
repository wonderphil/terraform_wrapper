module "aws_s3_terraform_state" {
  source        = "../aws_s3"
  name          = "${var.environment}-${substr(var.aws_region, 0, 2)}-terraform"
  kms_key_arn   = "${aws_kms_key.s3_kms_key.id}"
    
  tags {
    Name         = "${var.environment}-${substr(var.aws_region, 0, 2)}-terraform"
    environmet   = "${var.environment}"
    location     = "aws"
    role         = "terraform"
    service      = "${var.service}"
    owner        = "${var.owners}"
    encrptyed    = "true"
  } 
}