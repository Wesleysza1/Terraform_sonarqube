data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "sonarqube" {
  name               = "role-ec2-${var.app}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "sonarqube" {
  name = "iam-profile-${var.app}"
  role = aws_iam_role.sonarqube.name
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "${var.app}-policy-attach"
  roles      = [aws_iam_role.sonarqube.name]
  
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ])
  policy_arn = each.key
}

resource "aws_iam_policy" "secrets" {
  name        = "${var.app}-get-secrets"
  path        = "/"
  description = "Policy for get ${var.app} secrets on Secrets Manager"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"secretsmanager:ListSecrets",
				"secretsmanager:DescribeSecret",
				"secretsmanager:GetSecretValue",
				"secretsmanager:ListSecretVersionIds"
			],
			"Resource": [
			    "${var.arn_secret_postgresql_user}",
			    "${var.arn_secret_db_sonar_user}",
			    "${var.arn_secret_sonarqube_web_server_user}"
			  ]
		}
	]
  })
}

resource "aws_iam_policy_attachment" "policy" {
  name       = "${var.app}-secrets-policy-attach"
  roles      = [aws_iam_role.sonarqube.name]
  policy_arn = aws_iam_policy.secrets.arn
}