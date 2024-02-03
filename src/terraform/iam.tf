data "aws_iam_policy_document" "ec2AssumeRole" {
  statement {
    sid    = "assumeRole"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy" "ssm" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ssm" {
  name                = "SSMManagedInstanceRole"
  assume_role_policy  = data.aws_iam_policy_document.ec2AssumeRole.json
  managed_policy_arns = [data.aws_iam_policy.ssm.arn]
}

resource "aws_iam_instance_profile" "ssm" {
  name = "ssmRole"
  role = aws_iam_role.ssm.name
}


data "aws_iam_policy_document" "ecsAssumeRole" {
  statement {
    sid    = "assumeRole"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy" "ecsExecution" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "cloudwatch" {
  name = "CloudWatchLogsFullAccess"
}

resource "aws_iam_role" "ecsExecution" {
  name                = "ECSExecutionRole"
  assume_role_policy  = data.aws_iam_policy_document.ecsAssumeRole.json
  managed_policy_arns = [data.aws_iam_policy.ecsExecution.arn, data.aws_iam_policy.cloudwatch.arn ]
}