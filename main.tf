module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = local.dynamodb.table_name
}

module "appsync" {
  source            = "./modules/appsync"
  name              = local.appsync.name
  datasource_name   = local.appsync.datasource_name
  dynamo_table_name = module.dynamodb.dynamo_table_name
  dynamo_table_arn  = module.dynamodb.dynamo_table_arn
  resolvers         = local.appsync.resolvers
}
