output "sonarqube_ec2_id" {
  value = aws_instance.sonarqube.id
}
output "sg_sonarqube_id" {
  value = aws_security_group.sonarqube.id
}