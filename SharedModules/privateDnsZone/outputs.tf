output "dns_id" {
  value = azurerm_private_dns_zone.pvt_dns_zone.id
}

output "link_id" {
  value = azurerm_private_dns_zone_virtual_network_link.dns_vnet_link.id
}
