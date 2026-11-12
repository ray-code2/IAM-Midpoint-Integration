# Validation evidence

This file records observed results, not planned capabilities.

## Verified setup

- Existing GitHub main contains the original repository README.
- Local feature branch: `feat/phase1-foundation`, based on existing main.
- Ubuntu is installed as WSL 2.
- Ubuntu Git, Node 22, npm, Java compiler/runtime 21 and Maven are available.
- Docker Desktop was started and reports a Linux Docker server.
- Frontend lint, TypeScript checks, five behavior tests and Vite production build passed.
- Backend Maven verification passed: three HTTP/security tests, zero failures/skips.
- Backend verification was repeated successfully after Oracle-aware health was added.
- GitHub Actions syntax passed actionlint 1.7.12; Bash scripts passed `bash -n`.
- Staged-file review confirmed that `.env`, `.local`, dependencies and build outputs are excluded.

## Checks in progress

- Clean frontend install/check using the pinned Node 22.23.5 patch.
- Container build, Oracle migration/integration test and smoke checks.
- Source/image security scans.

## Not yet established

- Hosted GitHub Actions results and branch protection configuration.
- Independent reviewer, environment approval rules and development server.
- Real UAT/production deployment, backup/restore and rollback rehearsal.
- Application authentication, business authorization, audit ingestion and IAM features.
