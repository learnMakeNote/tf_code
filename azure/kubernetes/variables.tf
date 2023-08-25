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
  default = "kubernetes-the-kubespray-way"
}

variable "create_public_ip" {
  type = bool
  default = true
}

variable "publicIpInstanceCount" {
  type = object({
    controller = number
    worker = number
  })
  default = {
    controller = 3
    worker = 3
  }
}

variable "size" {
  type = string
  default = "Standard_B1s"
}

variable "linux_instance_count" {
  type = object({
    controller = number
    worker = number
  })
  default = {
    controller = 3
    worker = 3
  }
}

variable "windows_instance_count" {
  type = number
  default = 1
}



