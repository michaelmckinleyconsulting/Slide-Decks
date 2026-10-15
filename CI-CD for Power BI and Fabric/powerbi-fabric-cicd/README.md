# CI/CD for Power BI and Fabric: code samples

Companion code for Michael McKinley's session at Community Summit North America 2026.
Each folder maps to one part of the session. These are starting points: read them, test them
in a non-production tenant, and adapt them to your environment before you rely on them.

| Folder | What it does | Session section |
|---|---|---|
| `src/` | Where your Power BI Project (PBIP) items live: `*.SemanticModel` (TMDL) and `*.Report` (PBIR) folders. Point Fabric Git integration at `/src`. | Power BI is code now |
| `rules/Rules-Dataset.json` | Team Best Practice Analyzer rules. Severity 3 blocks a pull request; severity 2 is a warning. | CI guardrails |
| `pipelines/pr-validation.yml` | Azure Pipelines build that runs Tabular Editor 2's Best Practice Analyzer on every semantic model. Attach it to `main` as a Build Validation branch policy. | CI guardrails |
| `deploy/deploy.py` + `src/parameter.yml` | Code-first deployment with Microsoft's `fabric-cicd` library, with per-environment find/replace. | Deploying across environments |
| `pipelines/release.yml` | Azure Pipelines release: Test, then Prod behind an environment approval, deployed by a service principal. | Deploying across environments / audit trail |
| `terraform/` | Platform layer with the `microsoft/fabric` provider: Dev/Test/Prod workspaces, role assignments, and the Dev workspace's Git connection. | Where Terraform fits |

## 1. Power BI as code (PBIP + TMDL)

1. In Power BI Desktop, **File > Save as > Power BI Project (.pbip)** into `src/`.
2. In Fabric, open the Dev workspace > **Workspace settings > Git integration** and connect it to this repo, branch `main`, folder `/src`.
   Dev only *updates from* `main`: once the branch policies below are on, nobody commits to `main` directly, from Fabric or anywhere else.
3. Do your work on a feature branch: locally in Power BI Desktop, or in a Fabric workspace created with
   **Source control > Branch out to new workspace**. Commit, then open a pull request into `main`.
4. Link a work item to the pull request (or mention `#123` in a commit message to link work item 123).
5. After the PR merges, select **Update all** in the Dev workspace's Source control pane to pull the change in.

## 2. Guardrails on `main` (Azure Repos branch policies)

- Require a minimum number of reviewers, and leave **"Allow requestors to approve their own changes"** off.
- **Check for linked work items:** Required.
- **Check for comment resolution:** Required.
- **Build validation:** add `pipelines/pr-validation.yml`, Required.

To see the gate work, add a visible measure with no format string: the PR build fails on
`TEAM_MEASURE_FORMAT_STRING`. Add a format string and the build passes.

## 3. Deploy

**Option A: Fabric deployment pipelines (no code).** Dev, Test and Prod stages, compare before you deploy,
deployment rules for data sources and parameters, and deployment history in the Service.

**Option B: fabric-cicd (code-first).**

```bash
pip install fabric-cicd==1.4.0
python deploy/deploy.py --workspace-name "Sales [Dev]" --environment dev
```

In Azure DevOps, `pipelines/release.yml` runs the same script as a service principal. You need:

- an Azure Resource Manager service connection (workload identity federation recommended);
- the service principal as Contributor on the Test and Prod workspaces (the Terraform in `terraform/` assigns this);
- the Fabric tenant setting that lets service principals use Fabric APIs;
- ADO Environments `fabric-test` and `fabric-prod`, with an Approvals check on `fabric-prod`.

## 4. Terraform (platform layer)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars   # fill in your values
terraform init
terraform plan      # review exactly what will change
terraform apply
```

Authentication: the provider uses your Azure CLI sign-in by default. For user-context use it needs a one-time
Entra app registration and a scoped `az login`. The provider team walks through it here:
<https://blog.fabric.microsoft.com/en-US/blog/terraform-provider-for-microsoft-fabric-1-accelerating-first-steps-using-the-clis/>

`fabric_workspace_git` with `source = "Automatic"` uses a user identity. For a service principal, create a
Git connection in Fabric and use `source = "ConfiguredConnection"` with its `connection_id`.

## References

- PBIP and TMDL: <https://learn.microsoft.com/power-bi/developer/projects/projects-overview>
- Fabric Git integration: <https://learn.microsoft.com/fabric/cicd/git-integration/intro-to-git-integration>
- Build validation sample (Microsoft): <https://aka.ms/pbidevmode-ado-cipipeline>
- Deploy PBIP with fabric-cicd: <https://learn.microsoft.com/power-bi/developer/projects/projects-deploy-fabric-cicd>
- Fabric deployment pipelines: <https://learn.microsoft.com/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines>
- Terraform provider for Fabric: <https://registry.terraform.io/providers/microsoft/fabric/latest/docs>

Tabular Editor 2 is a free, open-source community tool. It isn't supported by Microsoft.

## License

The code in this folder is released under the [MIT License](LICENSE): use it, adapt it, ship it.
The slides in the parent folder are not covered by this license; they remain all rights reserved.
