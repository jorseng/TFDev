output "nsg" {
  value       = azurerm_network_security_group.nsg
}

output "nsg-rule-set" {
  value       = azurerm_network_security_rule.nsgRuleSet
}

output "nsg-association" {
  value       = azurerm_subnet_network_security_group_association.nsgAssociation
}