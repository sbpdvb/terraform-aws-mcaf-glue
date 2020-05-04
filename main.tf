data "aws_region" "current" {}

resource "aws_glue_job" "default" {
  name              = var.name
  connections       = var.connections
  default_arguments = var.default_arguments
  glue_version      = var.glue_version
  max_capacity      = var.max_capacity
  max_retries       = var.max_retries
  role_arn          = var.role_arn
  tags              = var.tags

  command {
    name            = var.command_name
    python_version  = var.python_version
    script_location = var.script_location
  }
}

resource "aws_glue_trigger" "default" {
  name     = var.name
  enabled  = var.active
  schedule = var.schedule
  type     = var.trigger_type
  tags     = var.tags

  actions {
    job_name = aws_glue_job.default.name
  }
}
