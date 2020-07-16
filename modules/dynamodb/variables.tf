variable table_name {
  description = "DynamoDB table name"
}

variable read_capacity {
  description = "Read capacity"
  default     = 1
}

variable write_capacity {
  description = "Write capacity"
  default     = 1
}
