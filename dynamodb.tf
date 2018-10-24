resource "aws_dynamodb_table" "tower-configuration" {
  name           = "auto-staging-tower-conf"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "towerStage"

  attribute {
    name = "towerStage"
    type = "S"
  }

  # Remaining attributes must be created in the application

  tags {
    Name        = "auto-staging-tower-conf"
    Environment = "production"
  }
}