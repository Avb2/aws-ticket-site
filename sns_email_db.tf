resource "aws_sns_topic" "notify_inactive_ticket" {
  name = "notify-inactive-ticket"
}


resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
    topic_arn = aws_sns_topic.notify_inactive_ticket.arn
    protocol  = "email"
    endpoint  = "bringuel.alexander@gmail.com"

    
}