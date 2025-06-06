resource "aws_sqs_queue" "primary-process-queue" {
  provider = aws.primary
  name = "transaction-process-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.primary-process-queue-dlq.arn
    maxReceiveCount = 5
  })
}

resource "aws_sqs_queue" "primary-process-queue-dlq" {
  provider = aws.primary
  name = "transaction-process-dlq"
}

resource "aws_sqs_queue" "primary-pipe-redrive-dlq" {
  provider = aws.primary
  name = "transaction-pipe-redrive-dlq"
}


resource "aws_sqs_queue" "secondary-process-queue" {
  provider = aws.secondary
  name = "transaction-process-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.secondary-process-queue-dlq.arn
    maxReceiveCount = 5
  })
}

resource "aws_sqs_queue" "secondary-process-queue-dlq" {
  provider = aws.secondary
  name = "transaction-process-dlq"
}

resource "aws_sqs_queue" "secondary-pipe-redrive-dlq" {
  provider = aws.secondary
  name = "transaction-pipe-redrive-dlq"
}
