resource "aws_sqs_queue" "process-queue" {
  name = "ue1-transaction-process-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.process-queue-dlq.arn
    maxReceiveCount = 5
  })
}

resource "aws_sqs_queue" "process-queue-dlq" {
  name = "ue1-transaction-process-dlq"
}

resource "aws_sqs_queue" "pipe-redrive-dlq" {
  name = "ue1-transaction-pipe-redrive-dlq"
}