resource "aws_secretsmanager_secret" "sonarqube_web_server" {
  name = "${var.app}/webserver"
  description = "${var.app} AWS web server credentials"
}

resource "random_password" "sonarqube_web_server" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret_version" "sonarqube_web_server" {
  secret_id = aws_secretsmanager_secret.sonarqube_web_server.id
  secret_string = jsonencode({
    user     = "admin"
    password = random_password.sonarqube_web_server.result
    url = ""
  })
}