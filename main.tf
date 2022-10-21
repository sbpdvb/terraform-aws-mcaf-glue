data "aws_region" "current" {}

resource "aws_glue_job" "default" {
  name              = var.name
  connections       = var.connections
  default_arguments = var.default_arguments
  glue_version      = var.glue_version
  #max_capacity      = var.max_capacity
  timeout           = var.timeout
  max_retries       = var.max_retries
  role_arn          = var.role_arn
  number_of_workers = var.command_name == "glueetl" ? var.number_of_workers : null
  worker_type       = var.command_name == "glueetl" ? var.worker_type : null
  tags              = var.tags
  execution_class   = var.execution_class
  command {
    name            = var.command_name
    python_version  = var.python_version
    script_location = var.script_location
  }
  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
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


  dynamic "predicate" {
    for_each = var.trigger_type == "CONDITIONAL" ? [1] : []
    content {
      conditions {
        job_name     = var.cond_job_name
        state        = var.cond_job_state
        crawler_name = var.cond_crawler_name
        crawl_state  = var.cond_crawler_state
      }
    }
  }
}


