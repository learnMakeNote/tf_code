# cloudwan core network id 
variable core_network_id {
  type        = string
  default     = "core-network-08c3a2f3f87fc59f3"
  description = "need to connect core network id"
}

# ASN code
variable ASN {
  type        = number
  default     = "65101"
  description = "ASN is customer_gateway code"
}

# all name prefix
variable global_name_prefix {
  type        = string
  default     = "jp-security-prod"
  description = "global name prefix for custome_gateway, vpn_connect and cloudwan_attachment"
}

# all segements
variable segements_name {
  type        = string
  default     = "shared"
  description = "cloudwan segements attachment tag env"
}

# custome IP and tunnels IP
variable default_gwIp_tunnelsIP {
  description = "List of customer Ip and each customer IP has 2 tunnels IP cidr"
  type  = list(object({
    gwIP          = string
    tunnels1      = string
    tunnels2      = string
    keys          = string
  }))
  default = [{
    gwIP    = "153.143.227.75"
    tunnels1  = "169.254.254.252/30"
    tunnels2  = "169.254.254.248/30"
    keys      = "kyowakirin"
  },{
    gwIP    = "153.143.227.76"
    tunnels1  = "169.254.254.244/30"
    tunnels2  = "169.254.254.240/30"
    keys      = "kyowakirin"
  }]
}

# site point name
variable site_point_name {
  description = "site point name"
  type = string
#  default = "TRP"
}


