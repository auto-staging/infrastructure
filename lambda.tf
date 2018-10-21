data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/go-src/bin/"
  output_path = "${path.module}/auto-staging-tower.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "auto-staging-tower"
  handler          = "auto-staging-tower"
  runtime          = "go1.x"
  filename         = "${path.module}/auto-staging-tower.zip"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  timeout          = 300
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogFullAccess" {
  role       = "${aws_iam_role.lambda_exec_role.name}"
  policy_arn = "${aws_iam_policy.lambda_execution.arn}"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "auto-staging-test-lambda-exec-role"

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
           "dynamodb:*"
           ],
           "Resource": "*"
       }
   ]
}
POLICY
}