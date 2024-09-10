output "arn_secret_postgresql_user" {
  value = aws_secretsmanager_secret.db_sonarqube.arn
}

output "arn_secret_db_sonar_user" {
  value = aws_secretsmanager_secret.db_sonar_user.arn
}

output "arn_secret_sonarqube_web_server_user" {
  value = aws_secretsmanager_secret.sonarqube_web_server.arn
}