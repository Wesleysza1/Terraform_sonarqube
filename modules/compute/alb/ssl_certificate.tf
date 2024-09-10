data "aws_acm_certificate" "issued" {
  domain   = var.ssl_domain
  statuses = ["ISSUED"]
}