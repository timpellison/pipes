resource "aws_dynamodb_table" "transaction_table" {
  hash_key  = "accountid"
  range_key = "transactionid"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "accountid"
    type = "S"
  }
  attribute {
    name = "transactionid"
    type = "S"
  }
  name             = "ue1-transaction-store"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

}

