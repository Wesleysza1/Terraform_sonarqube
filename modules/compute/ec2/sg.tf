# server security group
resource "aws_security_group" "sonarqube" {
  name        = "ec2-${var.app}-sg"
  description = "Security group para ec2 ${var.app}"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH Open from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    description = "TCP 9000 Open from VPC"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    description = "Open"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-${var.app}-sg"
  }
}