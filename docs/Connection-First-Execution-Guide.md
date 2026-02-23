# Connection-First Execution Guide

## Why This Comes Before Scoring

Scoring is only credible if source connectivity and extraction quality are verified first.  
This guide establishes a secure, professional way to prove live access before computing any maturity scores.

## Security Model (No Plaintext `.env`)

- Authentication: Entra ID (`DefaultAzureCredential`) for local and CI contexts.
- Secret retrieval: Azure Key Vault (`key_vault_uri` per environment in connector config).
- Secret usage: runtime retrieval only, no hardcoded values in repo.
- CI auth: OIDC federation from GitHub Actions to Azure.

## Execution Steps

1. Populate `scorecard/source-connectors.yaml` with real endpoints and Key Vault secret names.
2. Ensure Key Vault contains required secrets per environment.
3. Ensure identity has Key Vault `get/list` and source system read access.
4. Install probe dependencies:
- `just setup-scorecard`
5. Run live probe:
- `just scorecard-probe ENV=dev`
- `just scorecard-probe ENV=test`
- `just scorecard-probe ENV=prod`
6. Review output files:
- `scorecard/out/connection_probe_<env>.json`

## What The Probe Verifies

- Azure SQL/SQL endpoint network reachability (TCP probe)
- Databricks API authentication + API reachability
- Bigeye API token and endpoint reachability
- Alation API token and endpoint reachability

## Professional Controls

- Do not commit probe output containing sensitive endpoint metadata if policy disallows it.
- Route probe failures to remediation queue by source owner.
- Do not start scorecard calculations until all critical sources pass connectivity checks.

## Minimum Readiness Gate

For each environment:
- 100% critical source connectivity pass
- 0 missing required Key Vault secret references
- 0 unauthorized/forbidden responses for required APIs

Only then proceed to data extraction and scoring jobs.
