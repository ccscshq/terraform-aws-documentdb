module "network" {
  source = "git@github.com:ccscshq/terraform-aws-network.git?ref=v0.1.0"

  prefix                 = local.prefix
  ipv4_cidr              = local.ipv4_cidr
  ipv4_cidr_newbits      = local.ipv4_cidr_newbits
  subnets_number         = local.subnets_number
  create_private_subnets = true
}

module "docdb" {
  source = "../../"

  prefix = local.prefix

  cluster_identifier              = "${local.prefix}-cluster"
  engine_version                  = "5.0.0"
  master_username                 = "test"
  port                            = 27017
  backup_retention_period         = 1
  preferred_backup_window         = "10:00-10:30"
  apply_immediately               = false
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]
  preferred_maintenance_window    = "sun:04:00-sun:04:30"
  skip_final_snapshot             = false
  storage_encrypted               = false

  instance_count              = 2
  instance_identifier         = "instance"
  instance_class              = "db.t4g.medium"
  enable_performance_insights = false

  use_custom_parameter_group = true
  parameter_group_family     = "docdb5.0"
  parameter_group_parameter_overrides_immediately = {
    audit_logs = "enabled"
    profiler   = "enabled"
  }

  parameter_group_parameter_overrides_on_reboot = {
    change_stream_log_retention_duration = 3600
  }

  private_subnet_ids = module.network.private_subnet_ids
  vpc_id             = module.network.vpc_id

  allowed_cidr_blocks        = ["0.0.0.0/0"]
  allowed_security_group_ids = []
}
