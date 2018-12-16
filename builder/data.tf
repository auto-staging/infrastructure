data "aws_caller_identity" "current" {}

data "aws_dynamodb_table" "environments" {
  name = "auto-staging-environments"
}
