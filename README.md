# IAM-Midpoint-Integration

Engineering foundation for the IAM self-service portal: React + TypeScript,
Java 21 + Spring Boot, Oracle + Flyway, Docker, and GitHub Actions.

Repository: https://github.com/ray-code2/IAM-Midpoint-Integration

The repository name is preserved. This baseline follows the supplied custom
React/Spring Boot blueprint; it does not install or integrate Evolveum midPoint.
If midPoint is required, record that architecture decision before implementing
connectors or identity workflows.

**Start with [Ubuntu setup](docs/UBUNTU-SETUP.md), then [SDLC](docs/SDLC.md) and
[CI/CD](docs/CI-CD.md).** Actual validation evidence is in [VALIDATION](docs/VALIDATION.md).

## Scope and current behavior

This is the P0/M0 engineering foundation supporting Phase 1. The portal displays
backend health. Spring Security denies business API access until authentication
and authorization are implemented. With the `oracle` profile, startup validates
and applies the Oracle Flyway migration. There are no employee records, login
flows, approval workflows, or real AD/target application connections yet.

The blueprint is a design proposal; the requirements document is the business
reference. Phase 1 portal work is tracked in [the backlog](docs/PHASE-1-BACKLOG.md).

## Repository map

```text
.github/                 CI/CD, dependency updates, issue/PR templates, ownership
frontend/                React + TypeScript + Vite, UI tests
backend/                 Spring Boot, security baseline, Maven Wrapper, Java tests
database/migrations/     Oracle SQL bundled into the backend JAR by Maven
infrastructure/          Dockerfiles, Nginx, server deployment Compose file
scripts/                 Local checks, smoke tests, deployment script
security/                Versioned baseline SAST rules
docs/                    SDLC, setup, pipeline, decisions, backlog, evidence
docker-compose.yml       Local/CI application plus disposable Oracle
```

## Quick start in Ubuntu

Prerequisites: Node.js 22, Java JDK 21, Git, Docker with Compose, Python 3, curl.
Use Linux tools inside WSL; Windows Java installation alone is not sufficient.

```bash
bash scripts/check.sh
```

For development without Oracle, use two Ubuntu terminals:

```bash
# Terminal 1
cd backend
bash ./mvnw spring-boot:run
```

```bash
# Terminal 2
cd frontend
npm ci
npm run dev
```

Open http://localhost:5173. Vite proxies `/api` to the backend on port 8080.
This mode verifies the application shell only, not database connectivity.

For the complete local container stack, from the repository root:

```bash
cp .env.example .env
# Edit .env: provide two different random values for ORACLE_PASSWORD and DB_PASSWORD.
# Generate each value with: openssl rand -hex 24
docker compose up --build --detach --wait --wait-timeout 600
bash scripts/smoke.sh
```

Open http://localhost:8088. Oracle persists in a local named volume. Stop the stack
with `docker compose down`; this preserves database data. Never use the disposable
CI cleanup command against a database whose data you need.

## First GitHub milestone

1. Review the feature branch and local evidence.
2. Push `feat/phase1-foundation` and open a PR to `main`.
3. Inspect the `CI gate` check and fix failures before merging.
4. Configure branch rules and a second reviewer as described in the CI/CD guide.
5. Merge after review; successful main CI publishes the tested images to GHCR.
6. Configure the development server and environment before enabling deployment.

The workflow files do not create GitHub branch protections, environments, servers,
or approval policies. Server deployment defaults to disabled.
