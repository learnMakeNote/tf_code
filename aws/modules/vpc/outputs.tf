output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "internet_gateway_id" {
  description = "The Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "vpc_region" {
  description = "vpc region"
  value = data.aws_region.current
}

# output subnet
output "subnet_count" {
  description = "The number of subnets"
  value       = var.subnet_count
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.subnets.*.id
}
#
#output "route_table_ids" {
#  description = "List of route table IDs"
#  value       = aws_route_table.subnets.*.id
#}
