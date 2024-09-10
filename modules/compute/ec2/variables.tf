variable "app" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "private_subnet_ids" {}
variable "public_subnet_ids" {}

variable "arn_secret_postgresql_user" {}
variable "arn_secret_db_sonar_user" {}
variable "arn_secret_sonarqube_web_server_user" {}