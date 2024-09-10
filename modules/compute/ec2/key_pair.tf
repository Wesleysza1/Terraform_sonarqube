resource "tls_private_key" "sonarqube" {
  algorithm = "RSA"
}

module "key_pair" {
  depends_on = [tls_private_key.sonarqube]
  source     = "terraform-aws-modules/key-pair/aws"
  version    = "2.0.3"

  key_name   = "kp-${var.app}"
  public_key = tls_private_key.sonarqube.public_key_openssh
}

resource "aws_secretsmanager_secret" "kp_sonarqube" {
  depends_on = [module.key_pair]

  name = "ec2/kp-${var.app}"
  description = "Key Pair for access to Sonarqube AWS server"
}

resource "aws_secretsmanager_secret_version" "kp_sonarqube" {
  depends_on = [
    aws_secretsmanager_secret.kp_sonarqube,
    tls_private_key.sonarqube
  ]

  secret_id     = aws_secretsmanager_secret.kp_sonarqube.id
  secret_string = tls_private_key.sonarqube.private_key_pem
}