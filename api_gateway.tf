resource "aws_apigatewayv2_api" "api_gateway" {
    name          = "ticket-api"
    protocol_type = "HTTP"


    cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "OPTIONS"]
    allow_headers = ["*"]
    expose_headers = ["*"]
    max_age        = 3600
  }
}


resource "aws_apigatewayv2_authorizer" "cognito_auth" {
    api_id                            = aws_apigatewayv2_api.api_gateway.id
    authorizer_type                   = "JWT"
    identity_sources                  = ["$request.header.Authorization"]
    name = "cognito-auth"
    jwt_configuration {
        audience = [aws_cognito_user_pool_client.cognito_client_pool.id] 
       issuer = "https://cognito-idp.us-east-2.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"

    }
}


resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 5000
    throttling_rate_limit  = 10000
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId = "$context.requestId",
      status    = "$context.status"
    })
  }


}




# Route 1 - Create ticket


resource "aws_apigatewayv2_integration" "route1_integration" {
    api_id = aws_apigatewayv2_api.api_gateway.id
    integration_type = "AWS_PROXY"
    integration_method        = "POST"
    integration_uri           = aws_lambda_function.create_ticket_lambda.invoke_arn

}



resource "aws_apigatewayv2_route" "route1" {
    api_id    = aws_apigatewayv2_api.api_gateway.id
    route_key = "POST /create_ticket"
    target = "integrations/${aws_apigatewayv2_integration.route1_integration.id}"
    authorization_type = "JWT"
    authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
}














# Route 2 - Get ticket

resource "aws_apigatewayv2_integration" "route2_integration" {
    api_id = aws_apigatewayv2_api.api_gateway.id
    integration_type = "AWS_PROXY"
    integration_method        = "POST"
    integration_uri           = aws_lambda_function.get_ticket_lambda.invoke_arn

}



resource "aws_apigatewayv2_route" "route2" {
    api_id    = aws_apigatewayv2_api.api_gateway.id
    route_key = "GET /get_ticket"
    target = "integrations/${aws_apigatewayv2_integration.route2_integration.id}"
    authorization_type = "JWT"
    authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
}















# Route 3 - Check Tickets
resource "aws_apigatewayv2_integration" "route3_integration" {
    api_id = aws_apigatewayv2_api.api_gateway.id
    integration_type = "AWS_PROXY"
    integration_method        = "POST"
    integration_uri           = aws_lambda_function.check_db.invoke_arn

}



resource "aws_apigatewayv2_route" "route3" {
    api_id    = aws_apigatewayv2_api.api_gateway.id
    route_key = "GET /get_tickets"
    target = "integrations/${aws_apigatewayv2_integration.route3_integration.id}"
    authorization_type = "JWT"
    authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
}













# Route 4 - Update Tickets


resource "aws_apigatewayv2_integration" "route4_integration" {
    api_id = aws_apigatewayv2_api.api_gateway.id
    integration_type = "AWS_PROXY"
    integration_method        = "POST"
    integration_uri           = aws_lambda_function.resolve_lambda.invoke_arn

}



resource "aws_apigatewayv2_route" "route4" {
    api_id    = aws_apigatewayv2_api.api_gateway.id
    route_key = "PUT /resolve_ticket"
    target = "integrations/${aws_apigatewayv2_integration.route4_integration.id}"
    authorization_type = "JWT"
    authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
}
