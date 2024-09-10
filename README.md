# SonarQube Infrastructure on AWS with Terraform

This project is a Terraform code that automates the creation of the necessary infrastructure to run SonarQube on an EC2 instance in AWS. The code provisions the entire network, EC2, load balancing, security, and integrates secret storage via Secrets Manager.

## Project Structure

```bash
.
├── LICENSE
├── README.md
├── backend.tf
├── modules
│   ├── compute
│   │   ├── alb
│   │   │   ├── alb.tf
│   │   │   ├── ssl_certificate.tf
│   │   │   └── variables.tf
│   │   └── ec2
│   │       ├── ec2.tf
│   │       ├── instance_profile.tf
│   │       ├── key_pair.tf
│   │       ├── outputs.tf
│   │       ├── sg.tf
│   │       ├── sonar.sh
│   │       └── variables.tf
│   ├── network
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── vpc.tf
│   └── secrets
│       ├── outputs.tf
│       ├── postgres_secrets.tf
│       ├── sonar_secrets.tf
│       ├── sonarqube_web_secrets.tf
│       └── variables.tf
├── modules.tf
├── outputs.tf
├── provider.tf
└── variables.tf
```

## Features

- **AWS Infrastructure**: Creation of VPC, public and private subnets, load balancer (ALB), and EC2 instance to run SonarQube.
- **Security**: Security groups are configured to allow secure access to SonarQube through the ALB.
- **Secrets Manager**: All passwords and key pairs generated during execution are stored in AWS Secrets Manager for enhanced security.
- **SSL Integration**: The code requires a pre-existing SSL certificate, which will be applied to the ALB HTTPS listener.
- **Automation**: SonarQube installation and configuration on the EC2 instance are done automatically via scripts.

## Prerequisites

- **Terraform** installed ([installation instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli)).
- **Active SSL Certificate** in AWS ACM for the domain to be used.
- Configuration of variables for the AWS region and SSL certificate domain.

## Backend Configuration

The `backend.tf` file is configured to use **S3** and **DynamoDB**. This ensures:
- **S3**: Remote storage of the Terraform state, allowing multiple users to access the state consistently.
- **DynamoDB**: State locking, preventing multiple concurrent Terraform executions from corrupting the state.

## Variables

The `variables.tf` file contains variables that can be customized. Please review the file and change as needed.

### Key Variables

- **ssl_domain**: Ensure to provide the correct domain of the SSL certificate before executing the code.
- **region**: Change the AWS region if necessary. The default is `us-east-1`.
- **vpc_cidr**: Modify the VPC CIDR block if there are network restrictions.

## Running the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/Wesleysza1/Terraform_sonarqube
   ```

2. Modify the variables as necessary in the `variables.tf` file or pass them directly in the command.

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Run the plan to review the resources to be created:
   ```bash
   terraform plan
   ```

5. Apply the changes to create the infrastructure:
   ```bash
   terraform apply
   ```

## Notes

- **SSL Certificate**: This project does not create an SSL certificate. The certificate must be provisioned in AWS ACM, and the domain should be entered in the `ssl_domain` variable before execution.
- **Secrets Access**: The EC2 instance is configured with a role that allows access to the Secrets Manager values required for SonarQube installation and operation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.