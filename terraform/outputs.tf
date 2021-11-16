output "LB_URL" {
  value = aws_alb.spring_petclinic_alb.dns_name
}