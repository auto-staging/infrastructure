data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/go-builder/bin/"
  output_path = "${path.module}/auto-staging-builder.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "auto-staging-builder"
  handler          = "auto-staging-builder"
  runtime          = "go1.x"
  filename         = "${path.module}/auto-staging-builder.zip"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  timeout          = 300

  environment = {
    variables = {
      CONFIGURATION_LOG_LEVEL        = 4
      CLOUDWATCH_TO_LAMBDA_EXEC_ROLE = "${aws_iam_role.cloudwatch_event_exec_role.arn}"
    }
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = "${aws_iam_role.lambda_exec_role.name}"
  policy_arn = "${aws_iam_policy.lambda_execution.arn}"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "auto-staging-builder-lambda-exec-role"

  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "lambda_execution" {
  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
           "logs:CreateLogGroup",
           "logs:CreateLogStream",
           "logs:PutLogEvents",
           "codebuild:*",
           "iam:PassRole",
           "dynamodb:UpdateItem",
           "dynamodb:DeleteItem",
           "events:ListRules",
           "events:DeleteRule",
           "events:PutRule",
           "events:ListTargetsByRule",
           "events:RemoveTargets",
           "events:PutTargets",
           "*"
           ],
           "Resource": "*"
       }
   ]
}
POLICY
}
