resource "aws_ecs_service" "api" {
  name          = "orders-api"
  desired_count = 2
}

resource "aws_ecs_service" "relay" {
  name          = "orders-relay"
  desired_count = 1
}

resource "aws_ecs_service" "worker" {
  name          = "orders-worker"
  desired_count = 2
}

resource "aws_sqs_queue" "order_events_dlq" {
  name = "order-events-dlq"
}

resource "aws_sqs_queue" "order_events" {
  name = "order-events"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.order_events_dlq.arn
    maxReceiveCount     = 5
  })
}
