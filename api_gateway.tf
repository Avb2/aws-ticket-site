resource "aws_apigatewayv2_api" "api_gateway" {
    name          = "ticket-api"
    protocol_type = "HTTP"
}


resource "aws_apigatewayv2_authorizer" "cognito_auth" {
    api_id                            = aws_apigatewayv2_api.api_gateway.id
    authorizer_type                   = "JWT"
    identity_sources                  = ["$request.header.Authorization"]
    name = "cognito-auth"
    jwt_configuration {
        audience = [aws_cognito_user_pool_client.cognito_client_pool.id] 
        issuer   = "https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
    }
}



# Route 1


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



# Route 2

resource "aws_apigatewayv2_integration" "route2_integration" {
    api_id = aws_apigatewayv2_api.api_gateway.id
    integration_type = "AWS_PROXY"
    integration_method        = "GET"
    integration_uri           = aws_lambda_function.get_ticket_lambda.invoke_arn

}



resource "aws_apigatewayv2_route" "route2" {
    api_id    = aws_apigatewayv2_api.api_gateway.id
    route_key = "GET /get_ticket"
    target = "integrations/${aws_apigatewayv2_integration.route2_integration.id}"
    authorization_type = "JWT"
    authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
}




