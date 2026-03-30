resource "aws_dynamodb_table" "visitor_counter" {
  name         = "cloud-resume-visitors"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}
