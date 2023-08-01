data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = merge(var.tags, lookup(var.tags_for_resource, "aws_vpc", {}))
}

resource "aws_default_route_table" "vpc" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags                   = merge(var.tags, lookup(var.tags_for_resource, "aws_default_route_table", {}))
}

resource "aws_vpc_dhcp_options" "vpc" {
  count = var.enable_dhcp_options == true ? 1 : 0

  domain_name = coalesce(
    var.domain_name,
    "${data.aws_region.current.name}.compute.internal",
  )
  domain_name_servers = var.domain_name_servers
  tags                = merge(var.tags, lookup(var.tags_for_resource, "aws_vpc_dhcp_options", {Name: "alex_custom_dhcp_${count.index}"}))
}

resource "aws_vpc_dhcp_options_association" "vpc_dhcp" {
  count           = var.enable_dhcp_options == true ? 1 : 0
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.vpc[0].id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, lookup(var.tags_for_resource, "aws_internet_gateway", {Name: "alex_custom_igw"}))
}

# create subnet
resource "aws_subnet" "subnets" {
  count = var.subnet_count

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.subnet_count, 2)), count.index)
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.tags, {"type": lookup(var.tags_subnet, "subnet${count.index+1}", "")})
}

## 分割线
#
#resource "aws_route_table" "subnets" {
#  count = var.subnet_count
#
#  vpc_id           = aws_vpc.vpc.id
#  propagating_vgws = var.propagating_vgws
#
#  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_route_table", {}))
#}
#
#resource "aws_route_table_association" "default" {
#  count = var.subnet_count
#
#  subnet_id      = element(aws_subnet.subnets.*.id, count.index)
#  route_table_id = element(aws_route_table.subnets.*.id, count.index)
#}
#
##resource "aws_route" "nat_gateway" {
##  count = var.nat_gateway_count
##
##  destination_cidr_block = "0.0.0.0/0"
##  route_table_id         = element(module.subnets.route_table_ids, count.index)
##  nat_gateway_id         = element(var.nat_gateway_ids, count.index)
##}
#
## nat gateway create
#resource "aws_eip" "natgw" {
#  count = var.subnet_count
#
#  vpc = true
#}
#
#resource "aws_nat_gateway" "natgw" {
#  count = var.subnet_count
#
#  allocation_id = element(aws_eip.natgw.*.id, count.index)
#  subnet_id     = element(var.subnet_ids, count.index)
#  tags          = merge(var.tags, lookup(var.tags_for_resource, "aws_nat_gateway", {}))
#}

