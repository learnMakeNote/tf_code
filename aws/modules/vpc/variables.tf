variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "enable_dhcp_options" {
  description = "Enable creation of DHCP Options"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = string
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = string
  default     = false
}

variable "domain_name" {
  description = "The suffix domain to use by default when resolving non Full Qualified Domain Names, if left blank then <region>.compute.internal will be used"
  type        = string
  default     = ""
}

variable "domain_name_servers" {
  description = "List of name servers to configure in /etc/resolve.conf, defaults to the default AWS nameservers"
  type        = list(string)

  default = [
    "AmazonProvidedDNS",
  ]
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "tags_for_resource" {
  description = "A nested map of tags to assign to specific resource types"
  type        = map(map(string))
  default     = {}
}

variable "tags_subnet" {
  description = "subnet"
  type        = map(string)
  default     = {}
}

# Standard subnet variables
variable "subnet_count" {
  description = "The number of subnets to create"
  type        = string
}

#variable "subnet_ids" {
#  description = "A list of subnets to create gateways in"
#  type        = list(string)
#}

variable "availability_zones" {
  description = "A list of availability zones to create the subnets in"
  type        = list(string)
}

variable "propagating_vgws" {
  description = "A list of virtual gateways for route propagation"
  type        = list(string)
  default     = []
}

# Public subnet variables
variable "map_public_ip_on_launch" {
  description = "Assign a public IP address to instances launched into these subnets"
  type        = string
  default     = false
}

# Private subnet variables
variable "nat_gateway_count" {
  description = "The number of NAT gateways to use for routing, must match subnet_count and nat_gateway_ids"
  default     = 0
}

variable "nat_gateway_ids" {
  description = "A list of NAT Gateway IDs to use for routing"
  default     = []
}



