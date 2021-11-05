resource "aws_ecs_cluster" "spring_petclinic_cluster" {
  name = "spring_petclinic_cluster"
}

resource "aws_ecs_task_definition" "spring_petclinic_task_definition" {
  family = "service"
  container_definitions = jsonencode([
    {
      name  = "spring_petclinic"
      image = data.aws_ecr_image.spring_petclinic
    }
  ])
}

resource "aws_ecs_service" "spring_petclinic_service" {
  name            = "spring-petclinic"
  cluster         = aws_ecs_cluster.spring_petclinic_cluster
  task_definition = aws_ecs_task_definition.spring_petclinic_task_definition
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "spring_petclinic"
    container_port   = var.app-port
  }
}

data "aws_ecr_image" "spring_petclinic" {
  repository_name = "spring-petclinic_repository"
  image_tag       = "latest"
}