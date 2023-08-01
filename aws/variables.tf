#variable vpn_number {
#  description = "vpn number"
#  type = number
#  default = 2
#}

# this data for vpn
#variable custom_vpn {
#  description = "this data describe vpn"
#  type = list(object({
#    ASN = string
#    core_network_id = string
#    global_name_prefix  = string
#    default_gwIp_tunnelsIP = list(object({
#      gwIP          = string
#      tunnels1      = string
#      tunnels2      = string
#      keys          = string
#    }))
#  }))
##  default = [{
##    ASN = "65101"
##    core_network_id = "core-network-0e2a571c16321f933"
##    global_name_prefix = "jp-security-prod"
##    default_gwIp_tunnelsIP = [{
##      gwIP    = "153.143.227.75"
##      tunnels1  = "169.254.254.252/30"
##      tunnels2  = "169.254.254.248/30"
##      keys      = "kyowakirin"
##    },{
##      gwIP    = "153.143.227.76"
##      tunnels1  = "169.254.254.244/30"
##      tunnels2  = "169.254.254.240/30"
##      keys      = "kyowakirin"
##    }]
##  },{
##    ASNs = "65102"
##    core_network_id = "core-network-0e2a571c16321f933"
##    global_name_prefix = "jp-security-prod2"
##    default_gwIp_tunnelsIP = [{
##      gwIP    = "153.143.227.77"
##      tunnels1  = "169.254.254.236/30"
##      tunnels2  = "169.254.254.232/30"
##      keys      = "kyowakirin"
##    },{
##      gwIP    = "153.143.227.78"
##      tunnels1  = "169.254.254.228/30"
##      tunnels2  = "169.254.254.224/30"
##      keys      = "kyowakirin"
##    }]
##  }]
#}