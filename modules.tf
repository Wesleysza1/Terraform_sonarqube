module "alb" {
  source = "./modules/compute/alb"
  depends_on = [ module.ec2 ]

  app = var.app
  vpc_id        = module.network.vpc_id
  sonarqube_ec2_id = module.ec2.sonarqube_ec2_id
  sg_sonarqube_id = module.ec2.sg_sonarqube_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids
  ssl_domain = var.ssl_domain
}

module "ec2" {
  source = "./modules/compute/ec2"

  app           = var.app
  vpc_id        = module.network.vpc_id
  vpc_cidr              = var.vpc_cidr
  
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids

  arn_secret_postgresql_user = module.secrets.arn_secret_postgresql_user
  arn_secret_db_sonar_user = module.secrets.arn_secret_db_sonar_user
  arn_secret_sonarqube_web_server_user = module.secrets.arn_secret_sonarqube_web_server_user
}

module "network" {
  source = "./modules/network"

  app           = var.app
  region = var.region
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_cidrs   = var.public_subnet_cidrs
}

module "secrets" {
  source = "./modules/secrets"

  app = var.app
}