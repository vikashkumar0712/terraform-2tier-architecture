terraform {
  backend "s3" {
    bucket = "tf-remote-be"
    key = "backend/main.tfstate"
    region = "us-east-1"
    dynamodb_table = "statelock-tf"
    
  }
}