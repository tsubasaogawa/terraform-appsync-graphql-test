data "local_file" "graphql_schema" {
  filename = "modules/appsync/resources/schema.graphql"
}

resource "aws_appsync_graphql_api" "this" {
  name                = var.name
  authentication_type = "API_KEY"
  schema              = data.local_file.graphql_schema.content
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

data "local_file" "resolver_requests" {
  for_each = var.resolvers
  filename = "modules/appsync/resources/resolver_templates/${each.key}/request.template"
}

data "local_file" "resolver_responses" {
  for_each = var.resolvers
  filename = "modules/appsync/resources/resolver_templates/${each.key}/response.template"
}

resource "aws_appsync_resolver" "this" {
  for_each    = var.resolvers
  api_id      = aws_appsync_graphql_api.this.id
  field       = lookup(each.value, "field")
  type        = lookup(each.value, "type")
  data_source = lookup(each.value, "data_source") # aws_appsync_datasource.this.name

  request_template  = lookup(data.local_file.resolver_requests, each.key).content
  response_template = lookup(data.local_file.resolver_responses, each.key).content

  caching_config {
    caching_keys = [
      "$context.identity.sub",
      "$context.arguments.id"
    ]
    ttl = 60
  }
}
