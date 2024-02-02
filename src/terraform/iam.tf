data "aws_iam_policy_document" "assumeRole" {
  statement {
    sid = "assumeRole"
    effect = "Allow"
    principals {
        type = "Service"
        identifiers = [ 
            "ec2.amazonaws.com",
            "ecs.amazonaws.com" ]
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
    name = "SSMManagedInstanceRole"
    assume_role_policy = data.aws_iam_policy_document.assumeRole.json
    managed_policy_arns = [ data.aws_iam_policy.ssm.arn]
}

resource "aws_iam_instance_profile" "ssm" {
  name = "ssmRole"
  role = aws_iam_role.ssm.name
}