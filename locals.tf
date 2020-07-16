locals {
  project_name         = "graphql-test"
  project_name_for_uri = replace(local.project_name, "-", "_")
  dynamodb = {
    table_name = local.project_name
  }
  appsync = {
    name            = "appsync-${local.project_name}"
    datasource_name = "datasource_${local.project_name_for_uri}"
    resolvers = {
      single_user = {
        field       = "singleUser"
        type        = "Query"
        data_source = "datasource_${local.project_name_for_uri}"
      }
      create_user = {
        field       = "createUser"
        type        = "Mutation"
        data_source = "datasource_${local.project_name_for_uri}"
      }
    }
  }
}