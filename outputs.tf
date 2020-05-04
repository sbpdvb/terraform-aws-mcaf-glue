output "arn" {
  value       = aws_glue_job.default.arn
  description = "ARN of the Glue job"
}

output "id" {
  value       = aws_glue_job.default.id
  description = "The Glue job name"
}

output "role_arn" {
  value       = aws_iam_role.default[count.index].arn
  description = "ARN of the IAM Role"
}
