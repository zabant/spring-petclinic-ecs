data "aws_iam_policy_document" "ecs_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "ecr_pull_policy" {
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.region}:${var.aws_account_id}:secret:secret_name"]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "spring-petclinic-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_policy.json
  inline_policy {
    name   = "ecr-pull-policy"
    policy = data.aws_iam_policy_document.ecr_pull_policy.json
  }
  tags = {
    Name = "spring-petclinic-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

