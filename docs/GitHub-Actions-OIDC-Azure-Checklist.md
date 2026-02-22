# GitHub Actions OIDC to Azure Checklist

Use this checklist to configure GitHub Actions authentication to Azure without long-lived secrets.

## 1. Prerequisites

- Azure subscription and target resource groups (`dev`, `test`, `prod`)
- GitHub repository and environment protection rules
- Entra app registration or service principal dedicated to CI/CD
- Contributor approvals for IAM and federated credential setup

## 2. Define Environment Inputs

For each environment capture:
- Azure subscription ID
- Tenant ID
- Resource group name
- Target runtime (Container Apps / AKS / other)
- ACR name
- Key Vault name

Store these in a controlled config file or runbook.

## 3. Azure Identity Setup

1. Create or select CI/CD service principal:
- naming: `sp-edm-github-oidc-<env>`

2. Assign least-privilege roles at RG/resource scope:
- deploy role (Contributor or custom)
- `AcrPush` for image publishing (if pipeline builds/pushes images)
- Key Vault read role only if deployment reads secrets directly

3. Create federated credentials on the service principal:
- issuer: `https://token.actions.githubusercontent.com`
- audience: `api://AzureADTokenExchange`
- subject patterns:
- branch-based workflows (for `dev`)
- environment-based workflows (for `test`, `prod`)

## 4. GitHub Repository Configuration

For each environment (`dev`, `test`, `prod`):
- create GitHub Environment
- add required reviewers for `test` and `prod`
- set deployment branch rules

Add repository/environment secrets:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

Do not store Azure client secret when using OIDC.

## 5. Workflow Requirements

In workflow YAML:
- `permissions: id-token: write, contents: read`
- `azure/login@v2` with client/tenant/subscription IDs
- Deploy immutable artifact/image tag promoted across environments

## 6. Validation Checklist

1. Workflow can log in to Azure via OIDC in `dev`.
2. Workflow cannot deploy to `test`/`prod` without required approvals.
3. Workflow fails if run from unauthorized branch/ref.
4. Role scoping prevents out-of-scope resource changes.
5. Audit logs show federated identity sign-ins and deployment actions.

## 7. Security Controls

- Use separate service principals per environment if policy requires strict isolation.
- Enforce branch protection for deployment-triggering branches.
- Enforce pull request reviews and status checks before promotion.
- Rotate and review role assignments quarterly.
- Monitor sign-in logs and failed token exchanges.

## 8. Operational Runbook Entries

Document:
- principal IDs and ownership
- federated credential subject rules
- role assignments and scope
- rollback process if deployment fails
- emergency disable process for CI identity

## 9. First-Pass Environment Example

Use this as a starter map and replace with your real values.

| Environment | Subscription ID | Resource Group | ACR | Key Vault | Service Principal Name | Federated Subject Pattern |
|---|---|---|---|---|---|---|
| dev | `<sub-dev-id>` | `rg-edm-dev-app` | `acredmdev` | `kv-edm-dev-core` | `sp-edm-github-oidc-dev` | `repo:<org>/<repo>:ref:refs/heads/dev` |
| test | `<sub-test-id>` | `rg-edm-test-app` | `acredmtest` | `kv-edm-test-core` | `sp-edm-github-oidc-test` | `repo:<org>/<repo>:environment:test` |
| prod | `<sub-prod-id>` | `rg-edm-prod-app` | `acredmprod` | `kv-edm-prod-core` | `sp-edm-github-oidc-prod` | `repo:<org>/<repo>:environment:prod` |

## 10. GitHub Repository Creation Guidance

Yes, you need a GitHub repository for GitHub Actions to run.

Options:
1. Create via GitHub UI, then add remote locally:
   - `git remote add origin https://github.com/<org>/<repo>.git`
   - `git push -u origin main`
2. Create via GitHub CLI (`gh`) if available:
   - `gh repo create <org>/<repo> --private --source . --remote origin --push`

After repo creation:
- enable branch protections for `dev`, `main`, and patterns `release/*`, `hotfix/*`
- create GitHub environments: `dev`, `test`, `prod`
- add environment approvals (`test`, `prod`)
- add OIDC IDs (`AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`) per environment
