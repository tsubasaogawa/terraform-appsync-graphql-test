locals {
  misc = {
    project_name = "graphql-test"
  }
  dynamodb = {
    table_name = local.misc.project_name
  }
  appsync = {
    name            = "appsync-${local.misc.project_name}"
    datasource_name = "datasource-${local.misc.project_name}"
  }
}