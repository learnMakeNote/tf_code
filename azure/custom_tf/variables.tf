variable "create_resource_group" {
  type = bool
  default = true
}

variable "location" {
  type = string
  default = "eastus"
}

variable "resource_group_name" {
  type = string
  default = "alex-custom-rg"
}

variable "create_public_ip" {
  type = bool
  default = true
}

variable "linux_instance_count" {
  type = number
  default = 1
}

variable "size" {
  type = string
  default = "Standard_B1ls"
}



