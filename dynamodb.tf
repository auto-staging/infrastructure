resource "aws_dynamodb_table" "repositories" {
  name           = "auto-staging-tower-repositories"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "repository"

  attribute {
    name = "repository"
    type = "S"
  }

  # Remaining attributes must be created in the application

  tags {
    Name        = "auto-staging-tower-repositories"
    Environment = "production"
  }
}