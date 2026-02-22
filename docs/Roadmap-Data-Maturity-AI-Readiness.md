# Sundt Data Modernization Roadmap

## 1. Scope and Objective

This roadmap is designed to move the current Azure-based data platform (ADF, Databricks, ADLS, Azure SQL metadata, Power BI) toward an enterprise data maturity model while establishing clear AI readiness standards.

The roadmap assumes use of:
- Bigeye for data observability and reliability monitoring
- Alation for catalog, metadata stewardship, and data discovery

The plan is based on:
- `Sundt Documentation.docx` (dated October 20, 2023)
- repository context in `README.md`

## 2. Current-State Summary (From Documentation Review)

### Strengths already in place

- Metadata-driven ingestion and processing architecture (`adf.dataSource`, `adf.dataProcess`, `adf.dataProcessDependency`)
- Layered lakehouse design (raw/bronze/silver/gold)
- CI/CD in Azure DevOps for code promotion across environments
- Monitoring patterns in ADF and SQL logging views
- Existing security controls using Key Vault, IAM, and Databricks groups
- Bigeye and Alation are available to support observability and catalog maturity

### Gaps and risks to address first

- Key Vault secret promotion is manual across environments (high operational risk)
- Infrastructure-as-code appears partially abandoned after initial Terraform deployment (configuration drift risk)
- Dependency on specific approvers/admin contacts for release and runtime administration (key person risk)
- Power BI and other data domains are only partially documented
- No formal enterprise-wide data product ownership model described
- No explicit data quality SLOs, data contracts, or AI governance controls
- README did not yet include detailed additional source inventory
- Bigeye and Alation adoption patterns are not yet standardized as enterprise controls

## 3. Target Data Maturity Model

Use a 5-level model across 8 domains.

### Levels

- Level 1: Ad hoc
- Level 2: Repeatable
- Level 3: Defined
- Level 4: Managed
- Level 5: Optimized

### Domains

- Strategy and Operating Model
- Data Governance and Risk
- Architecture and Platform
- Data Engineering and Integration
- Data Quality and Observability
- Metadata and Lineage
- Analytics and Consumption
- AI and Advanced Analytics Readiness

## 4. Target State

- Enterprise data governance council with domain data owners and stewards
- Data product model for priority business domains
- Standardized ingestion, transformation, and serving patterns with data contracts
- Automated quality monitoring and SLA/SLO alerting
- Central catalog + lineage + glossary for critical datasets
- Automated environment parity controls (including secrets/config)
- AI-ready curated zones and feature-quality datasets with governance controls
- Bigeye and Alation embedded as standard capabilities in data product lifecycle gates

## 5. Phased Roadmap

## Phase 0: Mobilize and Baseline

### Outcomes

- Confirm scope, ownership, and success metrics
- Establish maturity baseline and AI-readiness baseline

### Actions

- Stand up program governance: sponsor, steering committee, workstream leads
- Complete source-system inventory (starting with README table)
- Run maturity assessment workshop against 8 domains
- Define critical data elements (CDEs) and top 10 business use cases
- Define initial KPI set (see Section 8)

### Deliverables

- Baseline scorecard
- Current-state architecture + process map
- Prioritized modernization backlog

## Phase 1: Stabilize Foundation

### Outcomes

- Reduce platform operational risk
- Improve environment consistency and deployment reliability

### Actions

- Implement automated secret/config promotion strategy (Key Vault + pipeline parameterization)
- Define IaC strategy going forward (Terraform reconciliation or alternative IaC path)
- Standardize release gates and remove single-approver bottlenecks
- Create operational runbooks for ADF, Databricks, and integration runtime ownership
- Implement minimum observability standards: pipeline reliability, freshness, failure root-cause tags
- Define Bigeye baseline monitors (freshness, volume, schema, anomaly) for priority data products
- Define Alation minimum metadata standard (owner, steward, glossary term, lineage, certification)

### Deliverables

- Platform reliability controls
- Environment promotion SOP
- Ownership and support model (RACI)
- Bigeye/Alation minimum control checklist

## Phase 2: Govern and Standardize Data Products

### Outcomes

- Shift from pipeline-centric to product-centric delivery
- Improve trust in data and reduce rework

### Actions

- Define data product template (owner, SLA, quality rules, lineage, access policy)
- Implement data quality checks at bronze/silver/gold handoffs
- Introduce schema-change management and data contracts with source owners
- Deploy catalog/glossary/lineage for high-value datasets
- Operationalize Alation certification workflow for trusted datasets
- Integrate Bigeye quality results into incident and triage workflows
- Expand documentation coverage for Power BI and non-documented sources

### Deliverables

- Data product operating model
- Quality rule library and exception workflow
- Cataloged and stewarded priority datasets
- Certified dataset inventory managed in Alation with linked quality status from Bigeye

## Phase 3: Scale Enterprise Maturity

### Outcomes

- Institutionalize governance and measurable performance
- Enable self-service safely

### Actions

- Domain-based governance cadence with recurring maturity reviews
- Require Alation catalog completeness and Bigeye monitor coverage in governance reviews
- Role-based access model standardization and periodic access recertification
- FinOps for data workloads (cluster utilization, job cost per domain/product)
- Expand CI/CD with automated test suites (unit, integration, data validation)
- Standardize semantic models and certified BI layer ownership

### Deliverables

- Maturity trend reports
- Data platform scorecards by domain
- Expanded certified semantic layer
- Domain scorecards include Bigeye health and Alation completeness metrics

## Phase 4: AI-Ready Data Enterprise

### Outcomes

- Production-ready AI data foundation
- Governed path from analytics to ML/GenAI use cases

### Actions

- Define AI governance controls: approved use cases, risk tiers, human review checkpoints
- Create AI-ready datasets/feature tables with versioning and lineage
- Add model monitoring inputs: drift, bias checks, data health indicators
- Publish reusable retrieval and feature engineering patterns
- Pilot 2-3 high-value AI use cases with business owners
- Gate AI candidate datasets on Bigeye reliability thresholds and Alation metadata completeness

### Deliverables

- AI readiness score by domain
- AI governance playbook
- Production AI pilot results and scale plan

## 6. AI Readiness Assessment Framework

Score each domain from 1-5 across the dimensions below.

## A. Data Quality and Reliability

- Freshness SLA defined and measured
- Completeness/validity/uniqueness checks automated
- Incident response workflow exists for data failures

## B. Data Accessibility and Usability

- Curated datasets documented and discoverable
- Access approval times are predictable
- Business-friendly semantic layer exists

## C. Governance and Risk

- Sensitive data classification exists (PII, confidential, regulated)
- Policy enforcement for masking, retention, and access is auditable
- Model input/output review process exists

## D. Metadata and Lineage

- End-to-end lineage from source to BI/AI assets
- Data definitions and ownership are formalized
- Schema/version history available

## E. Platform and MLOps Enablement

- Reproducible data/feature pipelines
- Versioned datasets/features for training/inference
- Monitoring for drift and training-serving skew

## F. Organizational Readiness

- Clear product owner + steward roles per domain
- Cross-functional operating model (data engineering, analytics, governance, risk)
- Training/adoption plan for business and technical users

## Readiness Interpretation

- 1.0-2.0: Not AI ready
- 2.1-3.0: Limited pilots only
- 3.1-4.0: Controlled production readiness
- 4.1-5.0: Enterprise-scale AI readiness

## 7. Ordered Execution Plan

1. Complete source inventory and ownership mapping.
2. Baseline maturity and AI readiness scoring workshop.
3. Confirm top business outcomes and use cases.
4. Define target architecture principles and security guardrails.
5. Implement high-priority reliability fixes (secret promotion, release gates, monitoring).
6. Define data product template and quality standards.
7. Catalog critical datasets in Alation and assign owners/stewards.
8. Operationalize Bigeye quality checks and SLA dashboards for priority pipelines.
9. Launch governance cadence and decision forum.
10. Publish maturity trend report and prioritized next-step backlog.

## 8. KPI Set for Program Tracking

- % critical pipelines meeting freshness SLA
- % critical datasets with named owner/steward
- % gold datasets with automated quality checks
- Mean time to detect and resolve data incidents
- % data assets with lineage and glossary entries
- Release success rate across environments
- % AI candidate use cases passing readiness threshold
- % priority data products covered by Bigeye monitors
- % priority data products cataloged and certified in Alation
- % incidents with linked Bigeye alert and Alation asset context

## 9. Recommended Workstreams and Owners

- Workstream 1: Platform Reliability and DevSecOps
- Workstream 2: Data Governance and Stewardship
- Workstream 3: Data Quality and Observability
- Workstream 4: Semantic Layer and Analytics Adoption
- Workstream 5: AI Readiness and Responsible AI Controls

Assign one accountable lead per workstream and track via steering committee.

## 10. Immediate Next Actions

- Populate README source inventory with missing systems
- Run a maturity + AI readiness workshop using Sections 3 and 6
- Prioritize the first 10 backlog items for Phase 1 stabilization
- Nominate owners for the five workstreams
