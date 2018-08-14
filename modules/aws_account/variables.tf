#dynamodb.tf
variable "environment" {
  description = "Environment that service is being built in"
  type        = "string"
}

variable "is_prod" {
  description = "Is the environmentproduction"
  type        = "string"
  default     = false
}

variable "role" {
  description = "The tag for role"
  type        = "string"
}

variable "service" {
  description = "service that is being built in"
  type        = "string"
}

variable "owners" {
  description = "Owners of the service"
  type        = "string"
}

#s3.tf
variable "aws_region" {
  description = "Region where infra will be built"
  type        = "string"
}
