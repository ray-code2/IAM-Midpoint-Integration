# Prompt for the next Phase 1 task

Paste this into your coding session opened in the Ubuntu/WSL repository:

```text
Work with me on Phase 1 of IAM-Midpoint-Integration.

First inspect the current branch, worktree and README. Read docs/SDLC.md,
docs/CI-CD.md, docs/PHASE-1-BACKLOG.md and docs/VALIDATION.md. Preserve existing
work and distinguish the supplied business requirements from proposed designs.

Stack: React + TypeScript + Vite, Java 21 + Spring Boot, Oracle + Flyway,
Docker Compose, GitHub Actions. Use Ubuntu Bash commands. Preserve the monorepo
and existing CI gate. Business API access currently defaults to deny.

Help me complete the next unfinished foundation checkpoint before starting a
business feature. Explain what each command achieves and how to verify it.
Never claim that a workflow is running or green without inspecting the actual
GitHub run. Keep deployment disabled until its server, secrets and approval
rules have been configured and verified.

Once the foundation is verified, select one small reviewed Phase 1 backlog
item. Specify its requirement IDs, allowed and denied behavior, API/schema
impact, audit expectations, and acceptance tests. Resolve the authentication
decision before adding authenticated business endpoints. Use synthetic data
and mock integrations for the pilot.

Implement on a feature branch, run the relevant checks, and prepare a reviewable
PR. Report what changed, what passed, what remains unverified, and the exact
next action I need to take. Do not implement all IAM modules in one change.
```
