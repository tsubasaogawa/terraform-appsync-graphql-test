# terraform-appsync-graphql-test

An example for using GraphQL with AWS AppSync provisioned by Terraform.
Terraform creates the following AWS resources:

- AppSync
  - 1 API
  - 1 Schema
  - 2 Resolvers
- DynamoDB
  - 1 Table (for datasource)
- IAM
  - 1 Role (+ 1 inline policy)

## Requirements

- terraform v0.12 or later
- awscli

## Setup

```bash
cd terraform-appsync-graphql-test
terraform init
terraform apply
```

## Architecture



## Example

```bash
# Setup
cd terraform-appsync-graphql-test
terraform init
terraform apply

# Set environment variables from tfstate
API_KEY=$(cat terraform.tfstate | jq -r '.outputs.appsync_api_key.value')
HOST=$(cat terraform.tfstate | jq -r '.outputs.appsync_api_uris.value.GRAPHQL' | grep -oP '[^/]+\.amazonaws.com')

# Call GraphQL
## Create user
curl \
  -H 'Content-Type: application/json' \
  -H "x-api-key: $API_KEY" \
  -H "Host: $HOST" \
  -X POST -d '
{
  "query": "mutation { createUser(name: \"yoshida\") { id name } }"
}
' https://$HOST/graphql

{"data":{"createUser":{"id":"2e591d0b-c4cd-41bd-b66a-ad637e506f5f","name":"yoshida"}}}

## Get User
curl \
  -H 'Content-Type: application/json' \
  -H "x-api-key: $API_KEY" \
  -H "Host: $HOST" \
  -X POST -d '
    {
      "query": "query { user(id: \"2e591d0b-c4cd-41bd-b66a-ad637e506f5f\") { name } }"
    }' \
  https://$HOST/graphql

{"data":{"user":{"name":"yoshida"}}}
```
