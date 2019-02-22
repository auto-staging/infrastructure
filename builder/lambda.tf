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
      CONFIGURATION_LOG_LEVEL        = "${var.log_level}"
      CLOUDWATCH_TO_LAMBDA_EXEC_ROLE = "${aws_iam_role.cloudwatch_event_exec_role.arn}"
      SCHEDULER_LAMBDA_ARN           = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:auto-staging-scheduler"
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
              "codebuild:CreateProject",
              "codebuild:DeleteProject",
              "codebuild:StartBuild",
              "codebuild:UpdateProject",
              "codebuild:BatchGetProjects",
              "iam:PassRole"
           ],
           "Resource": "*"
       },
       {
           "Effect": "Allow",
           "Action": [
              "events:DeleteRule",
              "events:ListTargetsByRule",
              "events:RemoveTargets",
              "events:PutTargets"
           ],
           "Resource": "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:rule/as-*"
       },
       {
           "Effect": "Allow",
           "Action": [
              "events:ListRules",
              "events:PutRule"
           ],
           "Resource": "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:rule/*"
       }, 
       {
           "Effect": "Allow",
           "Action": [
              "dynamodb:GetItem",
              "dynamodb:UpdateItem",
              "dynamodb:DeleteItem"
           ],
           "Resource": "${data.aws_dynamodb_table.environments.arn}"
       }  
   ]
}
POLICY
}
