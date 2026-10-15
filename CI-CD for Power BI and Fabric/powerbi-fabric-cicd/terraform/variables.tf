variable "project_name" {
  description = "Prefix for workspace names, e.g. Sales -> 'Sales [Dev]'."
  type        = string
  default     = "Sales"
}

variable "environments" {
  description = "One workspace is created per environment. 'Dev' is connected to Git."
  type        = list(string)
  default     = ["Dev", "Test", "Prod"]

  validation {
    condition     = contains(var.environments, "Dev")
    error_message = "environments must include \"Dev\" (exact case): it is the workspace connected to Git."
  }
}

variable "capacity_name" {
  description = "Display name of an active Fabric capacity."
  type        = string
}

variable "developer_group_id" {
  description = "Object ID of the Entra group for BI developers."
  type        = string
}

variable "deployer_object_id" {
  description = "Object ID of the release pipeline's service principal (Enterprise application)."
  type        = string
}

variable "ado_organization" {
  description = "Azure DevOps organization name."
  type        = string
}

variable "ado_project" {
  description = "Azure DevOps project name."
  type        = string
}

variable "ado_repository" {
  description = "Azure Repos repository name."
  type        = string
}
