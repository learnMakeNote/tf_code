# output vpcid
output "external_connect_vpc_id" {
  value = data.aws_vpcs.external-connect.ids
}