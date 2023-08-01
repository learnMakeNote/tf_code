
# GLOBAL NETWORK - Created only when indicated in var.create_global_network
resource "aws_networkmanager_global_network" "global_network" {
  count = var.global_network.create ? 1 : 0

  description = var.global_network.description

  tags = var.tags
}

# Local variable to determine if the base_policy has to be created
locals {
  create_base_policy = var.core_network.base_policy_regions == null ? false : true
}

# CORE NETWORK
resource "aws_networkmanager_core_network" "core_network" {
  description       = var.core_network.description
  global_network_id = var.global_network.create ? aws_networkmanager_global_network.global_network[0].id : var.global_network.id

  create_base_policy  = local.create_base_policy
  base_policy_regions = var.core_network.base_policy_regions

  tags = var.tags
}

# CORE NETWORK POLICY ATTACHMENT
resource "aws_networkmanager_core_network_policy_attachment" "policy_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = data.aws_networkmanager_core_network_policy_document.policy.json
}


# create resource share
resource "aws_ram_resource_share" "example" {
  provider  = aws.ram
  name                      = "alex_cloudwan"
  allow_external_principals = true

  tags = {
    Name = "alex_cloudwan"
  }
}

# association aws resource
resource "aws_ram_resource_association" "example" {
  provider  = aws.ram
  resource_arn       =  aws_networkmanager_core_network.core_network.arn
  resource_share_arn = aws_ram_resource_share.example.arn
}


# association to shared account (infrastructure-base-dev)
resource "aws_ram_principal_association" "sender_invite" {
  provider           = aws.ram
  principal          = var.shared_principal
  resource_share_arn = aws_ram_resource_share.example.arn
}


# current account receiver accept shared
#resource "aws_ram_resource_share_accepter" "receiver_accept" {
#  share_arn = aws_ram_principal_association.sender_invite.resource_share_arn
#}



