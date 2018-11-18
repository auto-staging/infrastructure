resource "aws_dynamodb_table" "repositories" {
  name           = "auto-staging-repositories"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "repository"

  attribute {
    name = "repository"
    type = "S"
  }

  # Remaining attributes must be created in the application

  tags {
    Name        = "auto-staging-repositories"
    Environment = "production"
  }
}

resource "aws_dynamodb_table" "environments" {
  name           = "auto-staging-environments"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "repository"
  range_key      = "branch"

  attribute {
    name = "repository"
    type = "S"
  }

  attribute {
    name = "branch"
    type = "S"
  }

  # Remaining attributes must be created in the application

  tags {
    Name        = "auto-staging-environments"
    Environment = "production"
  }
}

resource "aws_dynamodb_table" "global_config" {
  name           = "auto-staging-repositories-global-config"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "stage"

  attribute {
    name = "stage"
    type = "S"
  }

  # Remaining attributes must be created in the application

  tags {
    Name        = "auto-staging-repositories-global-config"
    Environment = "production"
  }
}
