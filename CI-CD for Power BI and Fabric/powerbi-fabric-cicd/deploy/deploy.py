"""Deploy the PBIP items in /src to a Fabric workspace with fabric-cicd.

Local (interactive sign-in):
    python deploy/deploy.py --workspace-name "Sales [Dev]" --environment dev

Azure DevOps (service principal already signed in by the AzureCLI@2 task):
    python deploy/deploy.py --workspace-name "Sales [Prod]" --environment prod --spn-auth

Requires: pip install fabric-cicd==1.4.0
Docs:     https://learn.microsoft.com/power-bi/developer/projects/projects-deploy-fabric-cicd
"""
import argparse
from pathlib import Path

from azure.identity import AzureCliCredential, InteractiveBrowserCredential
from fabric_cicd import FabricWorkspace, publish_all_items

parser = argparse.ArgumentParser(description="Deploy PBIP items to a Fabric workspace")
parser.add_argument("--workspace-name", required=True, help="Target workspace display name")
parser.add_argument("--environment", required=True, help="Environment key used in src/parameter.yml (dev, test, prod)")
parser.add_argument("--spn-auth", action="store_true", help="Use the identity signed in to Azure CLI (pipelines)")
args = parser.parse_args()

credential = AzureCliCredential() if args.spn_auth else InteractiveBrowserCredential()

workspace = FabricWorkspace(
    workspace_name=args.workspace_name,
    environment=args.environment,
    repository_directory=str(Path(__file__).resolve().parents[1] / "src"),
    item_type_in_scope=["SemanticModel", "Report"],  # fabric-cicd publishes models before the reports bound to them
    token_credential=credential,
)

publish_all_items(workspace)
