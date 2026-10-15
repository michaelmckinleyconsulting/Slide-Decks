# CI/CD for Power BI and Fabric

Git, TMDL, and deployment pipelines you can actually implement.

Presented at **Community Summit North America 2026**, Gaylord Opryland Resort, Nashville, October 15, 2026.

---

## Get the Materials

| | |
|---|---|
| **Slides (PDF)** | [CI-CD for Power BI and Fabric CSNA 26.pdf](CI-CD%20for%20Power%20BI%20and%20Fabric%20CSNA%2026.pdf): view in your browser |
| **Slides (PowerPoint)** | [CI-CD for Power BI and Fabric CSNA 26.pptx](CI-CD%20for%20Power%20BI%20and%20Fabric%20CSNA%2026.pptx): download, includes speaker notes |
| **Code samples** | [Browse the code](powerbi-fabric-cicd/) or [download the zip](powerbi-fabric-cicd.zip) |

---

## Overview

Two problems eventually push every serious BI team toward a real deployment process:

- **What changed, who changed it, and why?** A number moves or a visual breaks. The Power BI Service tells you part of the story, and for plenty of teams that's enough. When it isn't, you need Git.
- **Can you prove it to an auditor?** Under Sarbanes-Oxley or similar controls, the auditability and traceability of BI assets isn't optional. A Git-integrated deployment process becomes a requirement.

This session covers CI/CD for Power BI and Fabric: Git integration, branching strategies, deployment pipelines, how TMDL turns semantic models into versionable, auditable code, and where Terraform fits for teams that want to go further.

### Learning Objectives

1. Design a practical CI/CD pipeline for Power BI and Fabric that incorporates branching strategies, deployment pipelines, and appropriate governance guardrails for your team's environment.
2. Explain how Git integration and TMDL work together to transform Power BI and Fabric assets into versionable, auditable code that supports change tracking, collaboration, and compliance requirements.
3. Evaluate where Terraform fits into a Git-based deployment framework, understanding how it extends your pipeline to automate workspace provisioning and Fabric object management at scale.

---

## Session Outline

1. **Two problems that lead to CI/CD:** traceability and auditability
2. **Right-size your approach:** from doing nothing, to file versioning, to deployment pipelines, to Git + CI/CD
3. **Power BI is code now:** PBIP, TMDL, and PBIR, and what a measure change looks like in Git
4. **Branching and CI guardrails:** three branching strategies, branch policies, and build validation with the Best Practice Analyzer
5. **Promoting across environments:** Fabric deployment pipelines and code-first deployment with fabric-cicd
6. **The audit trail:** work item, commit, pull request, build, deployment, and activity log, mapped to change-management controls
7. **Where Terraform fits:** the platform layer (workspaces, roles, Git connections) versus the content layer (models and reports)

---

## Code Samples

The [`powerbi-fabric-cicd`](powerbi-fabric-cicd/) folder holds working starting points for everything in the session:

| Folder | What it does |
|---|---|
| `src/` | Where your Power BI Project (PBIP) items live, plus `parameter.yml` for per-environment values |
| `rules/` | Team Best Practice Analyzer rules; severity 3 blocks a pull request |
| `pipelines/pr-validation.yml` | Azure Pipelines build validation that runs the Best Practice Analyzer on every pull request |
| `deploy/deploy.py` | Code-first deployment with Microsoft's `fabric-cicd` library |
| `pipelines/release.yml` | Release pipeline: Test, then Prod behind an approval, deployed by a service principal |
| `terraform/` | Dev/Test/Prod workspaces, role assignments, and the Dev workspace's Git connection with the `microsoft/fabric` provider |

See the [samples README](powerbi-fabric-cicd/README.md) for setup steps. Test everything in a non-production tenant before you rely on it.

---

## Key Takeaways

- **Right-size first.** Match the rigor to the risk. Not every report needs a pipeline.
- **Start with PBIP and TMDL.** Once Power BI is text, you can diff it, review it, and merge it.
- **Let guardrails do the enforcing.** Branch policies and build validation beat good intentions.
- **Pick one promotion path and automate it.** Deployment pipelines or fabric-cicd, with an approval in front of Prod.
- **Terraform the platform, Git the content.** Use each tool for the layer it was built for.

---

## About the Author

**Michael McKinley** is a data analytics consultant, instructor, and Power BI evangelist with a passion for turning complexity into clarity. At White Cap Supply, he leads data intelligence efforts that empower senior leaders with actionable insights.

Outside the office, Michael coleads the Nashville Power BI User Group, teaches live training courses, and speaks at conferences to help others harness the full potential of Power BI, the Power Platform, and Microsoft Fabric.

### Connect

- LinkedIn: [/in/michaellmckinley](https://linkedin.com/in/michaellmckinley)
- X (Twitter): [@_mikemckinley_](https://twitter.com/_mikemckinley_)
- YouTube: [The Data Practitioner](https://www.youtube.com/@thedatapractitioner)
- Website: [https://www.mckinley.consulting](https://www.mckinley.consulting)

---

## Copyright and License

**Slides:** © 2026 Michael McKinley. All Rights Reserved. This presentation is shared for educational and reference purposes. Contact me for permission to use or adapt this content.

**Code samples:** the contents of [`powerbi-fabric-cicd`](powerbi-fabric-cicd/) (and `powerbi-fabric-cicd.zip`) are released under the [MIT License](powerbi-fabric-cicd/LICENSE).
