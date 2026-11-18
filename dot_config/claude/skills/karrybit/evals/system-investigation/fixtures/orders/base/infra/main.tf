resource "aws_ecs_service" "api" {
  name          = "orders-api"
  desired_count = 2
}
