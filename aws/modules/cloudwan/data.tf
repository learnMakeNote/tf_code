data "aws_networkmanager_core_network_policy_document" "policy" {
  core_network_configuration {
    vpn_ecmp_support = false
    asn_ranges       = ["64512-65534"]
    edge_locations {
      location = "us-east-1"
    }
    edge_locations {
      location = "ap-northeast-1"
    }
  }

  segments {
    name                          = "shared"
    description                   = "Segment for shared services"
    require_attachment_acceptance = true
  }

  segments {
    name                          = "prod"
    description                   = "Segment for prod services"
    require_attachment_acceptance = true
  }

  segment_actions {
    action     = "share"
    mode       = "attachment-route"
    segment    = "shared"
    share_with = ["*"]
  }

  attachment_policies {
    rule_number     = 100
    condition_logic = "or"

    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "env"
      value    = "shared"
    }
    action {
      association_method = "constant"
      segment            = "shared"
    }
  }
  attachment_policies {
    rule_number     = 200
    condition_logic = "or"

    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "env"
      value    = "prod"
    }
    action {
      association_method = "constant"
      segment            = "prod"
    }
  }
}

# get current account information
data "aws_caller_identity" "current" {
  provider  = aws.ram
}

# get vpc accross tags


