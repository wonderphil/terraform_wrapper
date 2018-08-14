##### TAGS #####
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "acl" {
  description = "ACL to apply to bucket"
  default     = "private"
}

variable "kms_key_arn" {
  description = " KMS Key to use for server side encryption"
  type        = "string"
}

variable "encrypt" {
  description = "Encrypt the s3 bucket at rest"
  type        = "string"
  default     = true
}
