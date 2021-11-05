#LB Security Group
resource "aws_security_group" "lb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.spring_petclinic_vpc.id

  ingress = [{
    description      = "Allows 80 from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = [""]
    security_groups  = [""]
    self             = false
  }]

  egress = [{
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = [""]
    security_groups  = [""]
    self             = false
  }]
}

resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = aws_vpc.spring_petclinic_vpc.id

  ingress = [{
    description      = "Allows 8080 from anywhere"
    from_port        = var.app-port
    to_port          = var.app-port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = [""]
    security_groups  = [aws_security_group.lb_sg.id]
    self             = false
  }]

  egress = [{
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = [""]
    security_groups  = [""]
    self             = false
  }]
}