# GLOBAL NETORK (if created)
output "global_network" {
  value       = var.global_network.create ? aws_networkmanager_global_network.global_network[0] : null
  description = "Global Network. Full output of aws_networkmanager_global_network."
}

# CORE NETWORK
output "core_network" {
  value       = aws_networkmanager_core_network.core_network
  description = "Core Network. Full output of aws_networkmanager_core_network."
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}