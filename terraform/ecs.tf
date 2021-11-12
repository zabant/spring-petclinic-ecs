resource "aws_ecs_cluster" "spring_petclinic_cluster" {
  name = "spring-petclinic-cluster"
  tags = {
    Name = "spring-petclinic-cluster"
  }
}

data "aws_ecr_image" "spring_petclinic" {
  repository_name = "spring-petclinic"
  image_tag       = "latest"
}

resource "aws_ecs_task_definition" "spring_petclinic_ecs_task" {
  family = "spring-petclinic-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "spring-petclinic-container",
      "image": "607828299252.dkr.ecr.us-east-1.amazonaws.com/spring-petclinic:latest",
      "entryPoint": [],
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "cpu": 5,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = {
    Name = "spring-petclinic-ecs-td"
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.spring_petclinic_ecs_task.family
}

resource "aws_ecs_service" "spring_petclinic_ecs_service" {
  name                 = "spring-petclinic-ecs-service"
  cluster              = aws_ecs_cluster.spring_petclinic_cluster.id
  task_definition      = "${aws_ecs_task_definition.spring_petclinic_ecs_task.family}:${max(aws_ecs_task_definition.spring_petclinic_ecs_task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
    security_groups = [
      aws_security_group.ecs_service_sg.id,
      aws_security_group.lb_sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.spring_petclinic_alb_tg.arn
    container_name   = "spring-petclinic-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.spring_petclinic_alb_listener]
}