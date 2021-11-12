resource "aws_appautoscaling_target" "spring_petclinic_ecs_asg_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.spring_petclinic_cluster.name}/${aws_ecs_service.spring_petclinic_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "spring-petclinic-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.spring_petclinic_ecs_asg_target.resource_id
  scalable_dimension = aws_appautoscaling_target.spring_petclinic_ecs_asg_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.spring_petclinic_ecs_asg_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "spring-petclinic-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.spring_petclinic_ecs_asg_target.resource_id
  scalable_dimension = aws_appautoscaling_target.spring_petclinic_ecs_asg_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.spring_petclinic_ecs_asg_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
}