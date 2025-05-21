resource "aws_pipes_pipe" "dynamo_to_sqs_pipe" {
  role_arn = aws_iam_role.pipes_role.arn
  name = "ue1-dynamo-to-sqs-pipe"
  source = aws_dynamodb_table.transaction_table.stream_arn
  target = aws_sqs_queue.process-queue.arn

  # target_parameters {
  #   sqs_queue_parameters {
  #     message_deduplication_id = ""
  #   }
  # }



  source_parameters {
    filter_criteria {
      filter {
        pattern = jsonencode({
          eventName = ["MODIFY"],
          dynamodb = {
            NewImage = {
              publishable = {
                BOOL = [true]
              }
            }
          }
        })
      }
    }
    dynamodb_stream_parameters {
      starting_position = "TRIM_HORIZON"

      batch_size = 5
      dead_letter_config {
        arn = aws_sqs_queue.pipe-redrive-dlq.arn
      }
      on_partial_batch_item_failure = "AUTOMATIC_BISECT"
    }
  }
  log_configuration {
    level = "TRACE"
    cloudwatch_logs_log_destination {
      log_group_arn = aws_cloudwatch_log_group.pipe-log-group.arn
    }
  }

}

resource "aws_cloudwatch_log_group" "pipe-log-group" {
  name = "ue1-pipes-log-group"
}