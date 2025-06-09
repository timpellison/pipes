# Piper

Piper is an example AWS solution for moving event records from DynamoDB out through an eventbridge pipe to SQS.
This creates a queue that a lambda could be triggered from whenever an event record is 
pushed through the stream thus enabling retries and redrives.

# Use Cases

## Transitioning from Dynamo to another store
As workloads evolve, sometimes we discover that our dynamo GSIs don't cut it.  One pattern
to support advanced query is to ship attributes from Dynamo we want to query on to OpenSearch.

This approach gives us the ability to ship all dynamo data to another store entirely or 
as mentioned above, to augment dynamo queries using Opensearch.

## Publishing events from DynamoDB

In event drive architecture, we may want to think about separating event publishing from our applications.
One possible approach would be to use event bridge pipes to ship events following writes to dynamodb.

## Integration

Another possibility with this approach.  Shipping the data to sqs (or another target) will make the event available for downstream.
Often, in single-table-design solutions, it's necessary to perform updates as a result of a write to Dynamo.  If the desire
is to make the secondary update asynchronous, this is the possible glue between the processes.

# Scenario
DynamoDB table is used to record parts of a transaction.  Multiple updates will occur over the course of assembling
the transaction and the application defines when a transaction in dynamodb is ready to proceed to the next steps.



# Usage

1. Get terraform
2. Switch to the .infra directory and choose single or dual region deployment
3. Run terraform init
4. Run terraform apply --auto-approve
5. Install GO
6. from a terminal in the piper root directory type in "go run cmd/cli/main.go [ENTER]"
7. Inspect Dynamo table and verify that sqs queue now has matching number of items in the queue
8. Run terraform destroy --auto-approve