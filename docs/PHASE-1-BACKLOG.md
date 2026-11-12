# Phase 1 delivery backlog

These are proposed delivery slices, not claims of completed business features.
Use `.github/ISSUE_TEMPLATE/feature.yml` when creating each GitHub issue.

| Milestone | Deliverable | Acceptance evidence | Requirement reference |
| --- | --- | --- | --- |
| M0 Foundation | Repo, SDLC, app shell, health, Oracle migration, containers, CI/CD | Local and hosted checks, first reviewed PR, verified dev deployment | Blueprint P0/M0 |
| M1 Identity and fixtures | Auth decision, synthetic employees, app catalog, roles, ownership scopes | Authenticated/anonymous and cross-user permission tests | SSP-09/10, INT-01, API design |
| M2 Request pilot | One employee submits access for one app; server checks UAM | Eligible request accepted; ineligible request denied and audited | SSP-02/03/04/05, IM-07 |
| M3 Approval pilot | Ordered EM then application-owner approval; reject path | Wrong actor and out-of-order actions denied; decisions audited | EM-01, PU-01/04, ADM-05/06 |
| M4 Mock fulfillment and history | Fully approved request creates idempotent mock job; outcome shown | No early/duplicate execution; failed execution differs from rejected request | IM-06, SSP-08, ADM-06 |
| M5 Pilot hardening | Delegation scope, notification outbox, negative tests, UAT and recovery | Reviewer sign-off and reproducible test evidence | SSP-07, EM-02/04, PU-03 |

The initial end-to-end pilot is employee -> request -> UAM -> EM -> owner -> mock
provisioning -> outcome/history. Full self-service scope (including password reset,
all request types and workflow-only handoff) needs its own reviewed stories before
Phase 1 can be declared complete. Recertification and later review/UAM-ticket
modules are outside this first pilot.

Do not silently treat approved access as successfully provisioned access. Keep
request status, approval decisions, execution job and actual access distinct.

Open decisions from the source documents include history retention, workflow-only
completion evidence, enable/disable notifications, duplicate SSP-06 wording,
auth provider, pilot app, and Oracle target version. The requirements list 18
end-to-end and 55 workflow-only apps; this foundation does not implement them.
