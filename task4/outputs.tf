output "machine_learning_workspace_id" {
  description = "Azure ML workspace resource ID"
  value       = azurerm_machine_learning_workspace.this.id
}

output "machine_learning_workspace_name" {
  description = "Azure ML workspace name"
  value       = azurerm_machine_learning_workspace.this.name
}