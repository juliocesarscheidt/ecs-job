#### role for ECS task execution ####
data "aws_iam_policy_document" "execution-policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ssm:GetParameters",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_role" "execution-role" {
  name_prefix        = "execution-role_"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "execution-role-policy" {
  role   = aws_iam_role.execution-role.id
  name   = "task-execution-role-policy"
  policy = data.aws_iam_policy_document.execution-policy.json
}

#### role for ECS task application ####
data "aws_iam_policy_document" "task-policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "s3:*"
    ]
  }
}

resource "aws_iam_role" "task-role" {
  name_prefix        = "task-role_"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "task-role-policy" {
  role   = aws_iam_role.task-role.id
  name   = "task-execution-role-policy"
  policy = data.aws_iam_policy_document.task-policy.json
}
