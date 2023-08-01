
locals {
  associate_vpc_id = data.aws_vpcs.external-connect.ids[0]
}

# private host zone attach vpc
resource "aws_route53_vpc_association_authorization" "example" {
  provider = aws.infra-dev
#  count = length(data.aws_vpcs.external-connect.ids)
  vpc_id =  local.associate_vpc_id
  zone_id = var.route53_zone_id
}

# vpc agree this request
resource "aws_route53_zone_association" "example" {
  provider = aws.external-connect

  vpc_id  = aws_route53_vpc_association_authorization.example.vpc_id
  zone_id = aws_route53_vpc_association_authorization.example.zone_id
}

# route53 resolver rules attach vpc
resource "aws_route53_resolver_rule_association" "example" {
  provider = aws.external-connect

  resolver_rule_id = var.resolver_id_rule
  vpc_id           = local.associate_vpc_id
}

# route53 resolver firewall rule group attach vpc
resource "aws_route53_resolver_firewall_rule_group_association" "example" {
  provider = aws.external-connect

  name                   = "dns_firewall_association"
  firewall_rule_group_id = var.resolver_firewall_id
  priority               = 101
  vpc_id                 = local.associate_vpc_id
}









