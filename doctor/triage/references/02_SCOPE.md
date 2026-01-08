# Scope

Ownership zones that triage must consider.

## Mandatory Zones

Every triage report must consider these zones, even if only to explicitly exclude them:

### 1. Backend Application Code

- API handlers
- Business logic
- Data access layers
- Background jobs
- Error handling

### 2. Frontend Build/Runtime

- Build configuration
- Runtime errors
- API client code
- State management
- Browser compatibility

### 3. CI/CD Pipelines

- Build steps
- Test execution
- Deployment scripts
- Artifact publishing
- Environment setup

### 4. Container Build & Images

- Dockerfile configuration
- Base image versions
- Build arguments
- Multi-stage builds
- Image registry issues

### 5. Kubernetes / Orchestration

- Deployment manifests
- Service definitions
- Ingress configuration
- Probes (liveness, readiness)
- RBAC and secrets
- Resource limits

### 6. Cloud Infrastructure (IaC)

- Terraform / Pulumi / CloudFormation
- Identity and access management
- Networking (VPCs, security groups)
- Storage configuration
- Service quotas

### 7. Configuration & Environment

- Environment variables
- Config files
- Feature flags
- Secrets management
- Per-environment overrides

### 8. Dependencies & Versions

- Package versions
- Lockfile consistency
- Transitive dependencies
- Version conflicts
- Security vulnerabilities

## Zone Exclusion

If a zone is not relevant, explicitly state why:

- "Zone: Frontend — Excluded because this is a backend-only service"
- "Zone: Kubernetes — Excluded because this runs on bare metal"

Never silently skip a zone.
