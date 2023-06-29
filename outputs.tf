output "arn" {
  value       = aws_glue_job.default.arn
  description = "ARN of the Glue job"
}

output "id" {
  value       = aws_glue_job.default.id
  description = "The Glue job name"
}

output "security_configuration_id" {
  value       = var.enable_security_configuration ? aws_glue_security_configuration.security[0].id : null
  description = "Glue security configuration name"
}
