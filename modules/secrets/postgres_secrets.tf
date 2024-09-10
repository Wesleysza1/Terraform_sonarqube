resource "aws_secretsmanager_secret" "db_sonarqube" {
  name = "${var.app}/postgresql"
  description = "${var.app} AWS postgres user credentials"
}

resource "random_password" "postgres" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret_version" "db_sonarqube" {
  secret_id = aws_secretsmanager_secret.db_sonarqube.id
  secret_string = jsonencode({
    user     = "postgres"
    password = random_password.postgres.result
  })
}