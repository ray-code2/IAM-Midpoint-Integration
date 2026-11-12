# ADR 0001: engineering foundation

Status: proposed baseline implemented for validation; deployment infrastructure
and authentication choices remain open.

## Decision

- Preserve the existing `IAM-Midpoint-Integration` GitHub repository and history.
- Use one monorepo for React/TypeScript, Java 21/Spring Boot, Oracle migrations,
  infrastructure, documentation and GitHub Actions.
- Use Ubuntu/WSL 2 locally and Ubuntu hosted CI runners.
- Use Maven Wrapper and npm lockfile for reproducible dependency resolution.
- Keep Oracle SQL in `database/migrations`; Maven packages it at `db/migration`.
- Use Oracle Free 23 for disposable tests; validate the organization's actual
  Oracle version before adopting this as a compatibility claim.
- Build and scan containers once, then publish those exact images to GHCR.
- Promote immutable digests from a verified main-push CI release manifest.
- Keep deployment runners isolated from PR jobs. Deployment remains opt-in.
- Deny all business API requests until the auth/authorization milestone is built.

## Consequences

This foundation is intentionally a small executable application. It gives CI
real builds and behavior to verify while leaving IAM feature work to reviewed
stories. The application currently has no midPoint dependency despite the repo
name; adding midPoint requires a separate decision.

Container base tags receive upstream patches and are scanned on every run.
Release images are immutable by digest, but rebuilding the same source later
can produce a different base image. Pin base-image digests if fully reproducible
rebuilds are an organizational requirement; update them through reviewed PRs.

Flyway currently runs with the application's environment DB identity at startup.
Before production, decide on a separate migration identity/job and a least-
privilege runtime identity, and rehearse backup/restore. Initial health-only code
is not authorization, audit, or operational readiness for the full IAM system.
