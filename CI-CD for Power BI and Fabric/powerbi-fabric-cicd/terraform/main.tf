# ---------------------------------------------------------------------------
# Platform layer for one BI project: Dev/Test/Prod workspaces on a capacity,
# the same role assignments everywhere, and Dev connected to Azure Repos.
# Content (models, reports) is NOT managed here; Git + pipelines handle that.
#
# Provider docs: https://registry.terraform.io/providers/microsoft/fabric/latest/docs
# ---------------------------------------------------------------------------

terraform {
  required_version = ">= 1.8, < 2.0"
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "~> 1.0"
    }
  }
}

# Uses your Azure CLI sign-in by default (see README for the one-time app
# registration). In a pipeline, use a service principal / OIDC instead.
provider "fabric" {}

data "fabric_capacity" "this" {
  display_name = var.capacity_name

  lifecycle {
    postcondition {
      condition     = self.state == "Active"
      error_message = "Capacity '${var.capacity_name}' is not Active."
    }
  }
}

# One workspace per environment, named the same way every time.
resource "fabric_workspace" "env" {
  for_each     = toset(var.environments)
  display_name = "${var.project_name} [${each.key}]"
  description  = "${var.project_name} ${each.key} workspace. Managed by Terraform."
  capacity_id  = data.fabric_capacity.this.id
}

# Developers can build in Dev and only view Test/Prod.
resource "fabric_workspace_role_assignment" "developers" {
  for_each     = fabric_workspace.env
  workspace_id = each.value.id
  principal = {
    id   = var.developer_group_id
    type = "Group"
  }
  role = each.key == "Dev" ? "Contributor" : "Viewer"
}

# The release pipeline's service principal deploys to Test and Prod only;
# Dev is fed by Git, so the pipeline gets no access there (least privilege).
resource "fabric_workspace_role_assignment" "deployer" {
  for_each     = { for env, ws in fabric_workspace.env : env => ws if env != "Dev" }
  workspace_id = each.value.id
  principal = {
    id   = var.deployer_object_id
    type = "ServicePrincipal"
  }
  role = "Contributor"
}

# Only Dev syncs with Git; Test and Prod are fed by the release pipeline.
# Dev tracks main and only updates from it: work happens on feature branches
# and reaches main through a pull request.
resource "fabric_workspace_git" "dev" {
  workspace_id            = fabric_workspace.env["Dev"].id
  initialization_strategy = "PreferRemote" # new workspace: pull content from the repo

  git_credentials = {
    source = "Automatic" # user identity; use "ConfiguredConnection" + connection_id for a service principal
  }

  git_provider_details = {
    git_provider_type = "AzureDevOps"
    organization_name = var.ado_organization
    project_name      = var.ado_project
    repository_name   = var.ado_repository
    branch_name       = "main"
    directory_name    = "/src"
  }
}
