module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "4.2.0"

  identifier = "terra-rds-mysql-${var.infra_env}"

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = "mysql"
  engine_version       = "8.0.28"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = var.instance_type

  allocated_storage     = var.storage_size
  max_allocated_storage = var.max_storage_size

  db_name  = var.default_db_name
  username = var.master_username

  create_db_subnet_group = true
  subnet_ids             = var.subnets
  vpc_security_group_ids = var.security_groups

  # Temporary fix for bug
  # Bug: Option group can't be deleted after the RDS instance is deleted due to final snapshot
  # https://github.com/terraform-aws-modules/terraform-aws-rds/issues/371
  skip_final_snapshot = true
}
