# Step 1. Create a IAM Role
# Step 2. Create a IAM Policy
# Step 3. Attach IAM policy with IAM role
# Step 4. Create instance profile and attached with IAM role

# Create iam role for confluence servers
resource "aws_iam_role" "confl-iam-role-basic" {
  name = "confl-iam-role-basic-${var.infra_env}"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name    = "confl-iam-role-basic-${var.infra_env}"
    Project = var.project
  }
}

# Create IAM Policy
resource "aws_iam_policy" "confl-iam-policy" {
  name = "confl-iam-policy-${var.infra_env}"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:List*"
        ],
        Effect : "Allow",
        Resource : [
          "arn:aws:s3:::software-lib",
          "arn:aws:s3:::software-lib/*"
        ]
      },
      {
        Action : [
          "ec2:Describe*",
          "ec2:Get*",
          "iam:Get*",
          "iam:List*",
          "elasticfilesystem:Describe*",
          "rds:Describe*",
          "rds:ListTagsForResource"
        ],
        Effect : "Allow",
        Resource : "*"
      }
    ]
  })
  tags = {
    Name    = "confl-iam-policy-${var.infra_env}"
    Project = var.project
  }
}

# Attached IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "confl-attach-iam-policies" {
  policy_arn = aws_iam_policy.confl-iam-policy.arn
  role       = aws_iam_role.confl-iam-role-basic.name
}

# Create EC2 Instance Profile and link with IAM role
resource "aws_iam_instance_profile" "confl-iam-instance-profile" {
  name = "confl-iam-instance-profile-${var.infra_env}"
  role = aws_iam_role.confl-iam-role-basic.name
}