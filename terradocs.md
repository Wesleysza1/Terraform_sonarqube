<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/compute/alb | n/a |
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./modules/compute/ec2 | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ./modules/secrets | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | The Application for which the environment is being created. | `string` | `"sonarqube"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | List of private subnet CIDRs | `list(string)` | <pre>[<br>  "10.20.1.0/24",<br>  "10.20.2.0/24"<br>]</pre> | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | List of public subnet CIDRs | `list(string)` | <pre>[<br>  "10.20.101.0/24",<br>  "10.20.102.0/24"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the infrastructure. Defaults to `us-east-1`. | `string` | `"us-east-1"` | no |
| <a name="input_ssl_domain"></a> [ssl\_domain](#input\_ssl\_domain) | Certificate domain that will be used in the ALB HTTPS listener. | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | `"10.20.0.0/16"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->