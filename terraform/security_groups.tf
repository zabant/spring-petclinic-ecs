# Security group for ECS Service
resource "aws_security_group" "ecs_service_sg" {
  name   = "ecs-service-sg"
  vpc_id = aws_vpc.spring_petclinic_vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lb_sg.id, aws_security_group.rds_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = [aws_security_group.rds_sg.id]
  }

  tags = {
    Name = "spring-petclinic-service-sg"
  }
}



# Security group for Application Load Balancer
resource "aws_security_group" "lb_sg" {
  name   = "load-balanser-sg"
  vpc_id = aws_vpc.spring_petclinic_vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "spring-petclinic-lb-sg"
  }
}




# Security group for RDS instance
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.spring_petclinic_vpc.id

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}



# Security group for VPC Endpoints
#resource "aws_security_group" "vpce" {
#  name   = "vpce-sg"
#  vpc_id = aws_vpc.spring_petclinic_vpc.id
#
#  ingress {
#    from_port       = 443
#    to_port         = 443
#    protocol        = "tcp"
#    security_groups = [aws_security_group.ecs_service_sg.id]
#  }
#
#  tags = {
#    Name = "vpce-sg"
#  }
#}

