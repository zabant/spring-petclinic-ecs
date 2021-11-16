resource "aws_cloudwatch_log_group" "log-group" {
  name = "spring-petclinic-logs"

  tags = {
    Name = "spring-petclinic-logs"
  }
}
