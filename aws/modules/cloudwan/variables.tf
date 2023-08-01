# Global Network variables
variable "global_network" {
  description = "create global network"
  type = object({
    create      = bool
    id          = optional(string)
    description = optional(string)
  })
  default = {
    create = true
  }

  # Validates that if the user indicates the creation of the global network (var.global_network.create), it does not pass any id (var.global_network.id)
  validation {
    condition     = (var.global_network.create && var.global_network.id == null) || (!var.global_network.create && var.global_network.description == null)
    error_message = "If you select the creation of a new Global Network (var.global_network.create to true), you need to provide a description (var.global_network.description). If not, you need to provide an ID of a current Global Network (var.global_network.id)."
  }

  # Either var.global_network.id or var.global_network.description has to be defined
  validation {
    condition     = var.global_network.id == null || var.global_network.description == null
    error_message = "Only var.global_network.id or var.global_network.description has to be defined (not both attributes)."
  }
}

# Core Network Variables
variable "core_network" {
  description = <<-EOF
  Core Network definition. The following attributes are required:
  - `description`     = (string) Core Network's description.
  - `base_policy_regions` = (optional|list(string)) List of AWS Regions to create the base policy in the Core Network. For more information about the need of the base policy, check the README document.
  ```
EOF
  type = object({
    description         = string
    base_policy_regions = optional(list(string))
  })

  default = {
    description = "core network value"
    base_policy_regions = ["ap-northeast-1"]
  }
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {
    Name = "alex_cloudwan"
  }
}

variable aws_region {
  description = "aws edge region"
  type = string
  default = "ap-northeast-1"
}

variable shared_principal {
  description = "need to share account or OU id"
  type = string
  default = "579827498682"
}


