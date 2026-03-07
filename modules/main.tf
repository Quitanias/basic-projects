resource "aws_db_instance" "rds_instance" {
  allocated_storage         = var.allocated_storage
  db_name                   = var.db_name
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  parameter_group_name      = var.parameter_group_name
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.replication_source_identifier != null ? "${var.db_name}-final-snapshot" : null
  username                  = var.db_username
  password_wo               = var.password_wo
  password_wo_version       = var.password_wo_version
}
