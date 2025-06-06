resource "aws_iam_role" "primary_pipes_role" {
  name = "primary-pipes-role"
  provider = aws.primary
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "pipes.amazonaws.com"
      }
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.main.account_id
        }
      }
    }
  })
}

resource "aws_iam_role" "secondary_pipes_role" {
  name = "secondary-pipes-role"
  provider = aws.secondary
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "pipes.amazonaws.com"
      }
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.main.account_id
        }
      }
    }
  })
}

resource "aws_iam_role_policy" "primary_pipes_source" {
  provider = aws.primary
  role = aws_iam_role.primary_pipes_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:SendMessage",
        ],
        Resource = [
          aws_sqs_queue.primary-process-queue.arn,
          aws_sqs_queue.primary-pipe-redrive-dlq.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ],
        Resource = [
          data.aws_dynamodb_table.primary_dynamo.stream_arn
        ]

      }
    ]
  })
}

resource "aws_iam_role_policy" "secondary_pipes_source" {
  provider = aws.secondary
  role = aws_iam_role.secondary_pipes_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:SendMessage",
        ],
        Resource = [
          aws_sqs_queue.secondary-process-queue.arn,
          aws_sqs_queue.secondary-pipe-redrive-dlq.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ],
        Resource = [
          data.aws_dynamodb_table.secondary_dynamo.stream_arn
        ]
      }
    ]
  })
}