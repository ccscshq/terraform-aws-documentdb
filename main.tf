resource "aws_docdb_cluster" "this" {
  cluster_identifier              = var.cluster_identifier
  apply_immediately               = var.apply_immediately
  engine_version                  = var.engine_version
  master_username                 = var.master_username
  master_password                 = aws_ssm_parameter.this.value
  port                            = var.port
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  skip_final_snapshot             = var.skip_final_snapshot
  db_subnet_group_name            = aws_docdb_subnet_group.this.name
  db_cluster_parameter_group_name = var.use_custom_parameter_group ? aws_docdb_cluster_parameter_group.this[0].name : null
  deletion_protection             = false
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  final_snapshot_identifier       = "${var.prefix}-final"
  preferred_maintenance_window    = var.preferred_maintenance_window
  vpc_security_group_ids          = [aws_security_group.this.id]
}

resource "aws_docdb_cluster_instance" "this" {
  count = var.instance_count

  identifier                   = "${var.instance_identifier}-${count.index}"
  apply_immediately            = var.apply_immediately
  cluster_identifier           = aws_docdb_cluster.this.id
  instance_class               = var.instance_class
  preferred_maintenance_window = var.preferred_maintenance_window
  enable_performance_insights  = var.enable_performance_insights
}

resource "aws_docdb_cluster_parameter_group" "this" {
  count = var.use_custom_parameter_group ? 1 : 0

  family = var.parameter_group_family
  name   = "${var.prefix}-${replace(var.parameter_group_family, ".", "-")}"

  dynamic "parameter" {
    for_each = var.parameter_group_parameter_overrides_immediately

    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "immediate"
    }
  }

  dynamic "parameter" {
    for_each = var.parameter_group_parameter_overrides_on_reboot

    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }
}

resource "aws_docdb_subnet_group" "this" {
  name       = "${var.prefix}-subnet-group"
  subnet_ids = var.private_subnet_ids
}
