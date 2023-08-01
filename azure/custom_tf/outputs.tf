output "current_config" {
  value = data.azurerm_client_config.current
}

output "resource_group_id" {
  value = azurerm_resource_group.rg[0].id
}

#output "cog" {
#  value = module.openai.openai_endpoint
#}

output "linux_public_ip" {
  value = try(data.azurerm_public_ip.pip[0].ip_address, null)
}

output "linux_vm_id" {
  value = module.linux.vm_id
}





