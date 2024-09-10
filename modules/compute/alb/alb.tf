module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.11.0"

  name    = "alb-${var.app}"
  vpc_id  = var.vpc_id
  subnets = [
    var.public_subnet_ids[0],
    var.public_subnet_ids[1]
    ]

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_description = "Default Security group for ${var.app} ALB"
  security_group_name = "alb-${var.app}-sg"
  security_group_tags = {
    "Name" = "alb-${var.app}-sg"
  }

  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.issued.arn

      forward = {
        target_group_key = "sonarqube"
      }
    }
  }

  target_groups = {
    sonarqube = {
      name = "tg-sonarqube"
      protocol         = "HTTP"
      port             = 9000
      target_type      = "instance"
      target_id        = var.sonarqube_ec2_id
    }
  }

  tags = {

  }
}