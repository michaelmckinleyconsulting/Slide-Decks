output "workspace_ids" {
  description = "Workspace ID per environment (use these in parameter.yml and pipelines)."
  value       = { for env, ws in fabric_workspace.env : env => ws.id }
}
