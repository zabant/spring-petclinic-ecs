data "aws_route53_zone" "dns" {
    provider = aws.region-master
    name     = var.dns-name
}

resource "aws_route53_record" "www" {
  provider = aws.region-master
  name    = "www.zabant-spring-petclinic-project.com"
  type    = "A"
  ttl     = "300"
  records = aws_eip.
  zone_id = data.aws_route53_zone.dns.zone_id
}