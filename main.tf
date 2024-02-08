data "aws_region" "current" {}

resource "aws_glue_job" "default" {
  name              = var.name
  connections       = var.connections
  default_arguments = var.default_arguments
  glue_version      = var.glue_version
  max_capacity      = var.max_capacity
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

  security_configuration = var.enable_security_configuration ? aws_glue_security_configuration.security[0].id : null
}



resource "aws_glue_trigger" "default" {
  count = var.trigger_type != null ? 1 : 0
  name     = "${var.name}-${var.trigger_type}"
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

resource "aws_glue_security_configuration" "security" {
  count = var.enable_security_configuration ? 1 : 0
  name  = var.name

  encryption_configuration {
    cloudwatch_encryption {
      kms_key_arn                = var.kms_key_arn
      cloudwatch_encryption_mode = var.cloudwatch_encryption_mode
    }

    job_bookmarks_encryption {
      kms_key_arn                   = var.kms_key_arn
      job_bookmarks_encryption_mode = var.job_bookmarks_encryption
    }

    s3_encryption {
      kms_key_arn        = var.kms_key_arn
      s3_encryption_mode = var.s3_encryption
    }
  }
}

