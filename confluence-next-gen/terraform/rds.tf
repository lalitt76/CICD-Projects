# Create subnet group for rds
resource "aws_db_subnet_group" "confl-db-sub-grp" {
  subnet_ids = [module.vpc.pub_sub_01,
  module.vpc.pub_sub_02]
  name = "confl-db-sub-grp"
  tags = {
    Name : "confl-db-sub-grp"
    Project : var.project
  }
}

# Create db parameters group
resource "aws_db_parameter_group" "confl-db-para-grp" {
  family = "postgres16"
  name   = "confl-db-para-grp"
  parameter {
    name  = "log_connections"
    value = "1"
  }
  tags = {
    Name : "confl-db-para-grp"
    Project : var.project
  }
}

# create db instance
resource "aws_db_instance" "confl-db-instance" {
  instance_class         = var.rds.db_instance
  identifier             = var.rds.identifier
  allocated_storage      = var.rds.storage_size
  engine                 = var.rds.eng
  engine_version         = var.rds.eng_ver
  username               = var.rds.db_user
  password               = data.aws_kms_secrets.confl-secrets.plaintext["rds_secret"]
  db_subnet_group_name   = aws_db_subnet_group.confl-db-sub-grp.name
  vpc_security_group_ids = [aws_security_group.confl-sgs-stack[var.sg_keys.rds].id]
  parameter_group_name   = aws_db_parameter_group.confl-db-para-grp.name
  publicly_accessible    = var.rds.pub_acc
  skip_final_snapshot    = var.rds.skip_final_snap
  multi_az               = var.rds.multi_az
}