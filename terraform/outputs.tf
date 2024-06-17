output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "public_ip_vm2" {
  value = azurerm_public_ip.terraform_public_ip_2.ip_address
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "private_ip_vm1" {
  value = azurerm_network_interface.netint1.private_ip_address
}