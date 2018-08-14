#Main.tf
variable "aws_region" {
  description = "Region where infra will be built"
  type        = "string"
}

variable "aws_profile" {
  description = "AWS Cred profile to be used"
  type        = "string"
}

variable "aws_account_id" {
  description = "Account ID that infra will be built under"
  type        = "string"
}

variable "environment" {
  description = "Environment that service is being built in"
  type        = "string"
}

variable "remote_state_backend" {
  description = "Where is the remote state stored"
  type        = "string"
  default     = "s3"
}

variable "remote_state_bucket" {
  description = "Bucket name of the remote state"
  type        = "string"
}

variable "remote_state_aws_accounts_key" {
  description = "Bucket key for the remote state of aws_accounts"
  type        = "string"
}

variable "remote_state_region" {
  description = "Region that the remote state is stored"
  type        = "string"
}

variable "remote_state_s3_kms_key" {
  description = "Bucket key for the remote state of aws_accounts"
  type        = "string"
}

variable "remote_state_profile" {
  description = "AWS Creds Profile used for remote state"
  type        = "string"
}


variable "owners" {
  description = "Owners of the service"
  type        = "string"
}

variable "role" {
  description = "The tag for role"
  type        = "string"
}

variable "service" {
  description = "Service that is being built in"
  type        = "string"
}

variable "location" {
  description = "which cloud is the service being built"
  type        = "string"
  default     = "aws"
}
