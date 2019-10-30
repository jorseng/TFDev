output "firewall" {
  value = azurerm_firewall.firewall
}

output "nat-rule-set" {
  value       = azurerm_firewall_nat_rule_collection.NATRuleSet
}

output "network-rule-set" {
  value       = azurerm_firewall_network_rule_collection.NetworkRuleSet
}

output "app-rule-set" {
  value       = azurerm_firewall_application_rule_collection.AppRuleSet
}