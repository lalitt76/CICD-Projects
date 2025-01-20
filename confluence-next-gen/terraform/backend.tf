terraform {
  backend "s3" {
    bucket         = "bkt-terraform-state-lmt"
    key            = "tf-state/backend-confluence"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}