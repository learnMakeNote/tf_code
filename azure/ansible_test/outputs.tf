output "current_config" {
  value = data.azurerm_client_config.current
}

output "resource_group_id" {
  value = azurerm_resource_group.rg[0].id
}

#output "cog" {
#  value = module.openai.openai_endpoint
#}

output "linux_public_ip_ubuntu" {
  value = try(data.azurerm_public_ip.pip_ubuntu[*].ip_address, null)
}

output "linux_public_ip_centos" {
  value = try(data.azurerm_public_ip.pip_centos[*].ip_address, null)
}

output "linux_vm_ubuntu_id" {
  value = module.linux_ubuntu.vm_id
}

output "linux_vm_centos_id" {
  value = module.linux_centos.vm_id
}





