# GitHub and Azure Environment Handoff Guide

## 1. Purpose

Provide a clear, role-based setup plan so:
- GitHub environment configuration can be completed by repository admin.
- Azure identity and access configuration can be completed by Azure admin.
- Both sides can validate end-to-end CI/CD deployment readiness.

## 2. Owner Split

## GitHub Admin (Repository Side)

- Create GitHub Environments: `dev`, `test`, `prod`
- Add environment-level secrets and variables
- Configure required reviewers for `test` and `prod`
- Configure branch protection rules
- Confirm workflow permissions (`id-token: write`) are enabled

## Azure Admin (Cloud Side)

- Create/confirm Entra service principals for GitHub OIDC
- Configure federated credentials for GitHub Actions
- Assign least-privilege roles to service principals by environment scope
- Confirm ACR, resource groups, Container Apps, and Key Vault access
- Validate OIDC login and deployment rights

## 3. Required Inputs

Collect and share these before setup:

| Field | Dev | Test | Prod | Owner |
|---|---|---|---|---|
| GitHub repo (`org/repo`) | TBD | TBD | TBD | GitHub Admin |
| `AZURE_CLIENT_ID` | TBD | TBD | TBD | Azure Admin |
| `AZURE_TENANT_ID` | TBD | TBD | TBD | Azure Admin |
| `AZURE_SUBSCRIPTION_ID` | TBD | TBD | TBD | Azure Admin |
| `ACR_NAME` | TBD | TBD | TBD | Azure Admin |
| `AZURE_RESOURCE_GROUP` | TBD | TBD | TBD | Azure Admin |
| `CONTAINER_APP_NAME` | TBD | TBD | TBD | Azure Admin |
| Required reviewers configured | N/A | TBD | TBD | GitHub Admin |

## 4. GitHub Admin Checklist

1. Open repository settings -> Environments.
2. Create environments:
- `dev`
- `test`
- `prod`
3. Add environment secrets for each environment:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
4. Add environment variables for each environment:
- `ACR_NAME`
- `AZURE_RESOURCE_GROUP`
- `CONTAINER_APP_NAME`
5. Set required reviewers:
- `test`: required reviewer(s)
- `prod`: required reviewer(s)
6. Configure branch protection rules:
- `main`, `dev`, `release/*`, `hotfix/*`
- require PR review and required status checks
- disable direct pushes and force pushes

## 5. Azure Admin Checklist

For each environment (`dev`, `test`, `prod`):

1. Create/confirm service principal:
- Naming convention: `sp-edm-github-oidc-<env>`
2. Configure federated credential:
- Issuer: `https://token.actions.githubusercontent.com`
- Audience: `api://AzureADTokenExchange`
- Subject pattern:
- `dev`: `repo:<org>/<repo>:ref:refs/heads/dev`
- `test`: `repo:<org>/<repo>:environment:test`
- `prod`: `repo:<org>/<repo>:environment:prod`
3. Assign least-privilege roles at required scope:
- Deployment role (`Contributor` or custom scoped role)
- `AcrPush` where workflow builds/pushes image
- Key Vault read role only if needed by deployment process
4. Verify target resources exist:
- ACR
- Resource group
- Container App
- Key Vault (if used in deployment)

## 6. End-to-End Validation Plan

1. Run `02-build-and-deploy-dev.yml` from `dev` branch.
Expected:
- OIDC login succeeds.
- Image builds in ACR.
- Container App in `dev` updates successfully.

2. Run `03-promote-test-and-prod.yml`:
- Auto test promotion from `release/*` push OR manual to `test`.
- Manual promotion to `prod` from `main` or `hotfix/*`.
Expected:
- `test` and `prod` require reviewer approval.
- Deployment uses immutable image tag.

3. Confirm logs:
- GitHub workflow logs successful.
- Azure sign-in logs show federated identity.
- Container App latest revision updates.

## 7. Troubleshooting Ownership

- OIDC token/login errors: Azure Admin
- Missing secrets/vars in workflow: GitHub Admin
- Branch or environment approval policy blocks: GitHub Admin
- Deployment permission denied in Azure: Azure Admin

## 8. Sign-Off Template

| Item | GitHub Admin Sign-Off | Azure Admin Sign-Off | Date |
|---|---|---|---|
| Environments configured | ✅/❌ | N/A | YYYY-MM-DD |
| Secrets/vars configured | ✅/❌ | ✅/❌ (values provided) | YYYY-MM-DD |
| Federated credentials configured | N/A | ✅/❌ | YYYY-MM-DD |
| Role assignments complete | N/A | ✅/❌ | YYYY-MM-DD |
| Dev deploy validated | ✅/❌ | ✅/❌ | YYYY-MM-DD |
| Test/prod promotion validated | ✅/❌ | ✅/❌ | YYYY-MM-DD |
