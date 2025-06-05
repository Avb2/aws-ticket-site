resource "aws_dynamodb_table" "ticket_table" {
    name           = "ticket-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 20
    write_capacity = 20
    hash_key       = "TicketId"
    range_key      = "CreatedAt"


    attribute {
        name = "TicketId"
        type = "N"
    }

    attribute {
        name = "CreatedAt"
        type = "N"
    }

    attribute {
        name = "Severity"
        type = "N"
    }

    attribute {
        name = "Status"
        type = "N"
    }

    attribute {
        name = "Description"
        type = "S"
    }
}