# create customer gateway
resource "aws_customer_gateway" "example" {
  count  = length(var.default_gwIp_tunnelsIP)

  bgp_asn    = var.ASN
  ip_address = var.default_gwIp_tunnelsIP[count.index].gwIP
  type       = "ipsec.1"
  tags = {
    Name = "${var.global_name_prefix}-cgw-${var.site_point_name}-${count.index + 1}"
  }
}

# create vpn 
resource "aws_vpn_connection" "example" {
  count  = length(var.default_gwIp_tunnelsIP)

  customer_gateway_id   = aws_customer_gateway.example[count.index].id
  type                  = "ipsec.1"
  tunnel1_inside_cidr   = var.default_gwIp_tunnelsIP[count.index].tunnels1
  tunnel1_preshared_key = var.default_gwIp_tunnelsIP[count.index].keys
  tunnel2_inside_cidr   = var.default_gwIp_tunnelsIP[count.index].tunnels2
  tunnel2_preshared_key = var.default_gwIp_tunnelsIP[count.index].keys
  tags = {
    Name = "${var.global_name_prefix}-vpn-${var.site_point_name}-${count.index + 1}"
  }
}

# create attachment
resource "aws_networkmanager_site_to_site_vpn_attachment" "example" {
  count  = length(var.default_gwIp_tunnelsIP)
  core_network_id    = var.core_network_id
  vpn_connection_arn = aws_vpn_connection.example[count.index].arn

  tags = {
     Name = "${var.global_name_prefix}-cwa-${var.site_point_name}-${count.index + 1}"
     env  = var.segements_name
  }
}



