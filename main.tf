module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = local.dynamodb.table_name
}

module "appsync" {
  source            = "./modules/appsync"
  name              = local.appsync.name
  datasource_name   = replace(local.appsync.datasource_name, "-", "_")
  dynamo_table_name = module.dynamodb.dynamo_table_name
  dynamo_table_arn  = module.dynamodb.dynamo_table_arn
}
