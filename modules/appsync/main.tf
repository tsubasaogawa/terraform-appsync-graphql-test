data "aws_iam_policy_document" "role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.role.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:Scan",
    ]
    resources = [
      var.dynamo_table_arn,
    ]
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.name}-policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_appsync_graphql_api" "this" {
  name                = var.name
  authentication_type = "API_KEY"
}

resource "aws_appsync_api_key" "this" {
  api_id = aws_appsync_graphql_api.this.id
}

resource "aws_appsync_datasource" "this" {
  api_id           = aws_appsync_graphql_api.this.id
  name             = var.datasource_name
  service_role_arn = aws_iam_role.this.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = var.dynamo_table_name
  }
}
