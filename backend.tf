terraform {
  backend "s3" {
    bucket         = "" #Nome do bucket S3
    key            = "sonarqube/terraform.tfstate"
    dynamodb_table = "" #Nome da tabela do DynamoDb
    region         = "us-east-1"
  }
}