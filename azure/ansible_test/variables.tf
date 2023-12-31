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
  default = "ansible-test-rg"
}

variable "create_public_ip" {
  type = bool
  default = true
}

variable "publicIpInstanceCount" {
  type = object({
    ubuntu = number
    centos = number
    windows = number
  })
  default = {
    ubuntu = 1
    centos = null
    windows = null
  }
}

variable "size" {
  type = string
  default = "Standard_B1ls"
}

variable "linux_instance_count" {
  type = object({
    ubuntu = number
    centos = number
  })
  default = {
    ubuntu = 1
    centos = null
  }
}

variable "windows_instance_count" {
  type = number
  default = 1
}



