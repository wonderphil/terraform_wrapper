resource "aws_dynamodb_table" "terraform_dynamodb_table" {
  count          = "${var.is_prod ? 1 : 0 }"
  name           = "terraform-state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled   = true
  }

  tags {
    Name         = "${var.environment}-aws-terraform-state-table"
    environmet   = "${var.environment}"
    location     = "aws"
    role         = "${var.role}"
    service      = "${var.service}"
    owner        = "${var.owners}"
    encrypted    = "true"
  }
}