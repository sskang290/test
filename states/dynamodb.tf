resource "aws_dynamodb_table" "dynamo_db_tables" {
  for_each = toset(concat(try(local.env.repos, []), local.common.repos)) # Merge env with common, taking env as prio. If env isn't set then skip.

  name           = each.key
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    "Name" = "dynamodb-table-${each.key}"
  }

}
