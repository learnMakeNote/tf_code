output "current_config" {
  value = data.azurerm_client_config.current
}

output "resource_group_id" {
  value = azurerm_resource_group.rg[0].id
}

#output "cog" {
#  value = module.openai.openai_endpoint
#}

output "linux_public_ip_controller" {
  value = try(data.azurerm_public_ip.pip_controller[*].ip_address, null)
}

output "linux_vm_ubuntu_id" {
  value = module.linux_controller.vm_id
}

output "linux_public_ip_worker" {
  value = try(data.azurerm_public_ip.pip_worker[*].ip_address, null)
}

output "linux_vm_centos_id" {
  value = module.linux_worker.vm_id
}

output "linux_private_ip_controller" {
  value = module.linux_controller.network_interface_private_ip
}

output "linux_private_ip_worker" {
  value = module.linux_worker.network_interface_private_ip
}





