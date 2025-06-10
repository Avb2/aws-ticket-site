resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/apigateway/ticket-api"
  retention_in_days = 7
}