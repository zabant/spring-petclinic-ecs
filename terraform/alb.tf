resource "aws_alb" "spring_petclinic_alb" {
  name               = "spring-petclinic-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public.id, aws_subnet.public2.id]
  security_groups    = [aws_security_group.lb_sg.id]

  tags = {
    Name = "spring-petclinic-alb"
  }
}

resource "aws_lb_target_group" "spring_petclinic_alb_tg" {
  name        = "spring-petclinic-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.spring_petclinic_vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "spring-petclinic-alb-tg"
  }
}

resource "aws_lb_listener" "spring_petclinic_alb_listener" {
  load_balancer_arn = aws_alb.spring_petclinic_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.spring_petclinic_alb_tg.id
  }
}