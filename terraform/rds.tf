resource "aws_db_subnet_group" "rds_subnet" {
  name       = "private"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]
}

resource "aws_db_instance" "PetclinicDB" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  port                   = 3306
  name                   = var.app_name
  username               = var.app_name
  password               = var.app_name
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
}