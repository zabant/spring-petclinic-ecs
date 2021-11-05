resource "aws_lb" "application_lb" {
  provider           = aws.region-master
  name               = "petclinic-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.private.id, aws_subnet.public.id]
  tags = {
    Name = "Petclinic-LB"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  provider = aws.region-master
  name = "app-lb-tg"
  port = var.app-port
  target_type = "ip"
  vpc_id = aws_vpc.spring_petclinic_vpc.id
  protocol = "HTTP"
}