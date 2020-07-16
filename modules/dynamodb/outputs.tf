output "dynamo_table_name" {
  value = aws_dynamodb_table.this.name
}

output "dynamo_table_arn" {
  value = aws_dynamodb_table.this.arn
}
