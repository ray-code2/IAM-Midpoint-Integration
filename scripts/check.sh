#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
(cd frontend && npm ci && npm run check)
(cd backend && bash ./mvnw --batch-mode --no-transfer-progress verify)
echo 'Application checks passed. Run the container/Oracle checks separately.'
