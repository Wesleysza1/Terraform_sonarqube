data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240801"]
  }

  owners = ["099720109477"] # Canonical AWS
}

resource "aws_instance" "sonarqube" {
  ami                  = data.aws_ami.ubuntu.id
  iam_instance_profile = aws_iam_instance_profile.sonarqube.name
  instance_type        = "t3.medium"

  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.sonarqube.id]
  user_data = file("./modules/compute/ec2/sonar.sh")
  user_data_replace_on_change = false

  key_name = module.key_pair.key_pair_name

  disable_api_termination     = false # if true enable termination protection
  associate_public_ip_address = false
  monitoring                  = false

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true

    tags = {

    }

  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    "Name"                 = "${var.app}"
  }

  lifecycle {}

}