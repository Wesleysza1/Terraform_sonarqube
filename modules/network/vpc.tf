module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "vpc-${var.app}"
  cidr = var.vpc_cidr

  azs              = var.availability_zones
  private_subnets  = var.private_subnet_cidrs
  private_subnet_names = ["pvt-subnet-vpc-${var.app}"]
  private_subnet_tags_per_az = {
    "${var.region}a" = {
      Name : "pvt-subnet-vpc-${var.app}-${var.region}a"
    },
    "${var.region}b" = {
      Name : "pvt-subnet-vpc-${var.app}-${var.region}b"
    }
  }
  public_subnets   = var.public_subnet_cidrs
  public_subnet_names = ["pub-subnet-vpc-${var.app}"]
  public_subnet_tags_per_az = {
    "${var.region}a" = {
      Name : "pub-subnet-vpc-${var.app}-${var.region}a"
    },
    "${var.region}b" = {
      Name : "pub-subnet-vpc-${var.app}-${var.region}b"
    }
  }

  map_public_ip_on_launch = false

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  single_nat_gateway     = false

  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.app}"
  }
}