resource "aws_iam_role" "cloudwatch_event_exec_role" {
  name = "auto-staging-scheduler-cloudwatch-events-exec-role"

  assume_role_policy = "${data.aws_iam_policy_document.cloudwatch_events_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_events_policy_attachment" {
  role       = "${aws_iam_role.cloudwatch_event_exec_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_events_execution.arn}"
}

data "aws_iam_policy_document" "cloudwatch_events_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "cloudwatch_events_execution" {
  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
              "lambda:InvokeFunction"
           ],
           "Resource": "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:function:auto-staging-scheduler"
       }
   ]
}
POLICY
}
