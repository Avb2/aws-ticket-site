
locals {
    external_id = "user_pool"
}

resource "aws_cognito_user_pool" "user_pool" {
    name = "ticket_sys_cog_pool"

    # Acct. Recovery
    account_recovery_setting {
        recovery_mechanism {
            name = "verified_email"
            priority = 1
        }

        recovery_mechanism {
            name = "verified_phone_number"
            priority = 2
        }
    }

    # MFA

    mfa_configuration = "ON"
    sms_authentication_message = "Your code is {####}"

    sms_configuration {
        external_id = local.external_id
        sns_caller_arn = aws_iam_role.sns_caller_role.arn
        sns_region = "us-east-1"
    }

    software_token_mfa_configuration {
        enabled = true
    }


    # Lambda conf`
    lambda_config {
        post_confirmation = aws_lambda_function.assign_user_lambda.arn
    }

}

resource "aws_cognito_user_pool_client" "cognito_client_pool" {
    name = "cognito-client-pool"
    user_pool_id = aws_cognito_user_pool.user_pool.id
    generate_secret = false
    
    explicit_auth_flows = [
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_SRP_AUTH"
    ]

    supported_identity_providers = ["COGNITO"]
}


# Admin group
resource "aws_cognito_user_group" "admin" {
    user_pool_id = aws_cognito_user_pool.user_pool.id
    name = "Admin"
    description = "Administrative user group"
}

# User group
resource "aws_cognito_user_group" "user" {
    user_pool_id = aws_cognito_user_pool.user_pool.id
    name = "User"
    description = "Standard user group"
    precedence = 1
}





# Policy/Role

data "aws_iam_policy_document" "sns_caller_policy_trust" {
    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "cognito-idp.amazonaws.com"
            ]
        }
        actions = [
            "sts:AssumeRole"
        ]
        }
    
}


data "aws_iam_policy_document" "sns_caller_policy_perms" {
    statement {
        effect = "Allow"
        actions = [
            "sns:Publish"
        ]
        resources = [
            aws_sns_topic.sns_res.arn
        ]
    }
}

resource "aws_iam_role" "sns_caller_role" {
    name = "sns_caller_role"
    assume_role_policy = data.aws_iam_policy_document.sns_caller_policy_trust.json
}


resource "aws_iam_role_policy" "sns_caller_role_policy" {
    name = "sns_caller"
    role = aws_iam_role.sns_caller_role.id
    policy = data.aws_iam_policy_document.sns_caller_policy_perms.json
}


