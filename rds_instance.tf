resource "aws_db_instance" "rds" {
  identifier           = "${lower(var.rds_dns)}"
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mysqldb"
  username             = "${var.db_username}"
  password             = "${random_string.rdsPassword.result}"
  parameter_group_name = "default.mysql5.7"
  apply_immediately    = "true"
  skip_final_snapshot  = "true"
  port                    = 3306
  
  tags = "${merge(var.tags,
    map("Name", "${var.rds_dns}")
  )}"
}

module "rds_alarms" {
  source         = "./RDS_ALARMS"
  db_instance_id = "${aws_db_instance.rds.id}"
  alarm_emails = "${var.alarm_emails}"
  regions        = "${var.regions}"
}