resource "aws_secretsmanager_secret" "db_sonar_user" {
  name = "${var.app}/postgresql/user/sonar"
  description = "${var.app} AWS sonar user credentials"
}

resource "random_password" "db_sonar_user" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret_version" "db_sonar_user" {
  secret_id = aws_secretsmanager_secret.db_sonar_user.id
  secret_string = jsonencode({
    user     = "sonar"
    password = random_password.db_sonar_user.result
  })
}