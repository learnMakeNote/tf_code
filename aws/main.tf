
#module "vpn" {
#  source = "./modules/vpn"
#
#  ASN = var.custom_vpn[count.index].ASN
#  core_network_id = var.custom_vpn[count.index].core_network_id
#  global_name_prefix = var.custom_vpn[count.index].global_name_prefix
#  default_gwIp_tunnelsIP = var.custom_vpn[count.index].default_gwIp_tunnelsIP
#  vpn_number = var.vpn_number
#}

## route53 host zone create
#module "public_hosted_zone" {
#  source  = "./modules/route53"
#  version = "~> 1.0.0"
#
#  domain      = "example.com"
#  description = "Created by Terraform module example"
#  tags = {
#    environment = "development"
#  }
#}

module "private_hosted_zone" {
  source  = "./modules/route53"

  domain      = "alex.test."
  description = "Created by Terraform module example"
  private_zone = {
    vpc_id     = "vpc-09da7df03143844ef"
    vpc_region = "ap-northeast-1"
  }
  tags = {
    environment = "development"
  }

}



