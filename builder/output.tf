output "codebuild_role_arn" {
  value = "${aws_iam_role.codebuild_exec_role.arn}"
}
