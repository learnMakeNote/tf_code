# need to binding route53 id
variable route53_zone_id {
  type = string
  # default = "Z09425342ASV1D59KS8GK"
  description = "this is route53 id need to bind"
}

# need to bind resolver rule id
variable resolver_id_rule {
  type = string
  # default = "rslvr-rr-30942a4d94cf42748"
  description = "this is resolver rule id need to bind"
}

# need to bind resolver firewall rule group id
variable resolver_firewall_id {
  type = string
  # default = "rslvr-frg-cdbbde2ef49447c2"
  description = "this is resolver firewall id need to bind"
}



##### aws token content ####

# route53 account
variable route53_account_access_key {
  type = string
  description = "route53 account access_key"
}

variable route53_account_secret_key {
  type = string
  description = "route53 account secret_key"
}

variable route53_account_token {
  type = string
  description = "route53 account token"
}

# vpc account
variable vpc_account_access_key {
  type = string
  description = "vpc account access_key"
}

variable vpc_account_secret_key {
  type = string
  description = "vpc account secret_key"
}

variable vpc_account_token {
  type = string
  description = "vpc account token"
}


