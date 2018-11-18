resource "aws_api_gateway_rest_api" "gateway" {
  name        = "Auto Staging Tower API"

  body = "${data.template_file.openapi.rendered}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

data "template_file" "openapi" {
  template = "${file("swagger.yml")}"

  vars {
    tower_lambda_arn = "${aws_lambda_function.lambda.arn}"
    tower_lambda_execution_role_arn = "${aws_iam_role.api_exec_role.arn}"
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.gateway.execution_arn}/*/*"
}

resource "aws_iam_role" "api_exec_role" {
  name = "auto-staging-test-api-gateway-exec-role"

  assume_role_policy = "${data.aws_iam_policy_document.api-assume-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "APIGatewayPolicyAttachment" {
  role       = "${aws_iam_role.api_exec_role.name}"
  policy_arn = "${aws_iam_policy.api_execution.arn}"
}

data "aws_iam_policy_document" "api-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "api_execution" {
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
           "lambda:InvokeFunction"
           ],
           "Resource": "*"
       }
   ]
}
POLICY
}