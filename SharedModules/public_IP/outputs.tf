output "datacenter_ips" {
  value = azurerm_public_ip.all.ip_address
}