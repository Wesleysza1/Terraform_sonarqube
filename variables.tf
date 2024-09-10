variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region to deploy the infrastructure. Defaults to `us-east-1`."
}

variable "app" {
  type        = string
  default     = "sonarqube"
  description = "The Application for which the environment is being created."
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.20.101.0/24", "10.20.102.0/24"]
}

variable "ssl_domain" {
  description = "Certificate domain that will be used in the ALB HTTPS listener."
  type = string
  default = ""
}