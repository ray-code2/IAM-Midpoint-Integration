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
- Clean install, lint/types, five frontend tests and build passed on Node 22.23.5.
- Draft PR #1 is open; CI run 43148327339 passed frontend, backend and source-security jobs.
- That hosted run built both containers and passed HTTP smoke checks plus the
  Oracle migration/re-execution/insert/read test (one integration test, zero skips).
- Its image scan failed because the runner ran out of disk while downloading the
  Java vulnerability database. CI gate failed and publication was skipped. The
  workflow now reclaims disposable Oracle/build-cache storage before scanning.
- The actual gate script was also checked with success/failure/cancelled/skipped
  job results: only the all-success scenario returned exit code zero.
- GitHub confirms the repository is private. Its rulesets API returned HTTP 403:
  this account needs an eligible paid plan for private-repository rulesets.

## Checks in progress

- Complete hosted verification after the runner disk-space fix, including image scans.
- Local full-stack image download is still in progress; hosted integration results
  above do not establish local full-stack startup.

## Dependency advisory triage

The npm high/critical gate passed on retry and in hosted CI. npm reports ten
moderate findings in development tooling, all rooted in minimatch and its ESLint/
TypeScript-ESLint dependents (GHSA-g3hv-75wg-m249). They are not silently suppressed.
Track upstream compatible updates; do not use an unreviewed forced downgrade or
override. The production frontend image contains static assets, not this tooling.

## Not yet established

- Complete hosted CI gate and branch protection configuration.
- Independent reviewer, environment approval rules and development server.
- Real UAT/production deployment, backup/restore and rollback rehearsal.
- Application authentication, business authorization, audit ingestion and IAM features.
