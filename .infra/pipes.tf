resource "aws_pipes_pipe" "dynamo_to_sqs_pipe" {
  role_arn = aws_iam_role.pipes_role.arn
  name = "ue1-dynamo-to-sqs-pipe"
  source = aws_dynamodb_table.transaction_table.stream_arn
  target = aws_sqs_queue.process-queue.arn
  source_parameters {
    dynamodb_stream_parameters {
      starting_position = "TRIM_HORIZON"
      batch_size = 5
      dead_letter_config {
        arn = aws_sqs_queue.pipe-redrive-dlq.arn
      }
      on_partial_batch_item_failure = "AUTOMATIC_BISECT"
    }
  }
}