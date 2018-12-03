data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/go-scheduler/bin/"
  output_path = "${path.module}/auto-staging-scheduler.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "auto-staging-scheduler"
  handler          = "auto-staging-scheduler"
  runtime          = "go1.x"
  filename         = "${path.module}/auto-staging-scheduler.zip"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  timeout          = 300
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = "${aws_iam_role.lambda_exec_role.name}"
  policy_arn = "${aws_iam_policy.lambda_execution.arn}"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "auto-staging-scheduler-lambda-exec-role"

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
           "ec2:DescribeInstances",
           "ec2:StartInstances",
           "ec2:StopInstances",
           "rds:DescribeDBClusters",
           "rds:ListTagsForResource",
           "rds:StartDBCluster",
           "rds:StopDBCluster"
           ],
           "Resource": "*"
       }
   ]
}
POLICY
}
