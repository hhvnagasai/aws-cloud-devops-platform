resource "aws_db_subnet_group" "this" {
  name       = var.db_identifier
  subnet_ids = var.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.db_identifier}-subnet-group"
    }
  )
}

resource "aws_db_instance" "this" {
  identifier = var.db_identifier

  engine         = "mysql"
  engine_version = var.engine_version

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.master_username
  port     = var.port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  storage_encrypted = true
  kms_key_id        = var.kms_key_arn

  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.kms_key_arn

  backup_retention_period = var.backup_retention_period

  publicly_accessible = false
  deletion_protection = var.deletion_protection
  skip_final_snapshot = true

  auto_minor_version_upgrade = true

  tags = var.common_tags
}
