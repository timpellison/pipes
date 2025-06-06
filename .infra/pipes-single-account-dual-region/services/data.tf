data "aws_caller_identity" "main" {
  provider = aws.primary
}

data "aws_dynamodb_table" "primary_dynamo" {
  provider = aws.primary
  name = "transaction-store"
}

data "aws_dynamodb_table" "secondary_dynamo" {
  provider = aws.secondary
  name = "transaction-store"
}