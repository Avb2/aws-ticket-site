resource "aws_dynamodb_table" "ticket_table" {
    name           = "ticket-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 20
    write_capacity = 20
    hash_key  = "UserId"
    range_key = "TicketId"

    attribute {
        name = "UserId"
        type = "S"
    }


    attribute {
        name = "TicketId"
        type = "N"
    }

    attribute {
        name = "CreatedAt"
        type = "N"
    }

    attribute {
        name = "Status"
        type = "N"
    }



    global_secondary_index {
        name = "query_unchecked_tickets"
        hash_key = "Status"
        range_key = "CreatedAt"
        projection_type = "ALL"
        read_capacity   = 10
        write_capacity  = 10
    }
}


