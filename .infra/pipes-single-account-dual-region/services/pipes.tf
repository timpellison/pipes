resource "aws_pipes_pipe" "primary_dynamo_to_sqs_pipe" {
  provider = aws.primary
  role_arn = aws_iam_role.primary_pipes_role.arn
  name = "dynamo-to-sqs-pipe"
  source = data.aws_dynamodb_table.primary_dynamo.stream_arn
  target = aws_sqs_queue.primary-process-queue.arn

  # target_parameters {
  #   sqs_queue_parameters {
  #     message_deduplication_id = ""
  #   }
  # }



  source_parameters {
    filter_criteria {
      filter {
        pattern = jsonencode({
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
        arn = aws_sqs_queue.primary-pipe-redrive-dlq.arn
      }
      on_partial_batch_item_failure = "AUTOMATIC_BISECT"
    }
  }
  log_configuration {
    level = "TRACE"
    cloudwatch_logs_log_destination {
      log_group_arn = aws_cloudwatch_log_group.primary-pipe-log-group.arn
    }
  }
}

resource "aws_pipes_pipe" "secondary_dynamo_to_sqs_pipe" {
  provider = aws.secondary
  role_arn = aws_iam_role.secondary_pipes_role.arn
  name = "dynamo-to-sqs-pipe"
  source = data.aws_dynamodb_table.secondary_dynamo.stream_arn
  target = aws_sqs_queue.secondary-process-queue.arn

  # target_parameters {
  #   sqs_queue_parameters {
  #     message_deduplication_id = ""
  #   }
  # }



  source_parameters {
    filter_criteria {
      filter {
        pattern = jsonencode({
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
        arn = aws_sqs_queue.secondary-pipe-redrive-dlq.arn
      }
      on_partial_batch_item_failure = "AUTOMATIC_BISECT"
    }
  }
  log_configuration {
    level = "TRACE"
    cloudwatch_logs_log_destination {
      log_group_arn = aws_cloudwatch_log_group.secondary-pipe-log-group.arn
    }
  }
}

resource "aws_cloudwatch_log_group" "primary-pipe-log-group" {
  provider = aws.primary
  name = "pri-pipes-log-group"
}


resource "aws_cloudwatch_log_group" "secondary-pipe-log-group" {
  provider = aws.secondary
  name = "pri-pipes-log-group"
}
