#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${DEPLOY_ENV:?Missing deployment environment}"
: "${FRONTEND_IMAGE:?Missing frontend digest}"
: "${BACKEND_IMAGE:?Missing backend digest}"
: "${RELEASE_SHA:?Missing release commit}"
: "${JDBC_URL:?Missing database URL}"
: "${DB_USERNAME:?Missing database username}"
: "${DB_PASSWORD:?Missing database password}"
[[ "$DEPLOY_ENV" =~ ^(development|uat|production)$ ]]
[[ "$RELEASE_SHA" =~ ^[0-9a-f]{40}$ ]]
[[ "$FRONTEND_IMAGE" =~ ^ghcr\.io/[a-z0-9._/-]+/frontend@sha256:[0-9a-f]{64}$ ]]
[[ "$BACKEND_IMAGE" =~ ^ghcr\.io/[a-z0-9._/-]+/backend@sha256:[0-9a-f]{64}$ ]]
[[ "${APP_PORT:-8088}" =~ ^[0-9]+$ ]]

state_dir="/opt/iam/$DEPLOY_ENV"
test -d "$state_dir" && test -w "$state_dir" || {
  echo "Provision $state_dir with runner ownership before enabling deployment." >&2
  exit 1
}
# Protect against deployments started outside GitHub's concurrency group too.
exec 9>"$state_dir/deploy.lock"
flock --nonblock 9 || { echo 'Another deployment is active.' >&2; exit 1; }
compose=(docker compose --project-name "iam-$DEPLOY_ENV" -f infrastructure/compose.deploy.yml)
"${compose[@]}" config --quiet
"${compose[@]}" pull
"${compose[@]}" up --detach --wait --wait-timeout 300
bash scripts/smoke.sh "http://127.0.0.1:${APP_PORT:-8088}"

# Update the last-known-good record only after startup, migration, and smoke checks.
if [[ -f "$state_dir/current.json" ]]; then
  cp "$state_dir/current.json" "$state_dir/previous.json"
fi
python3 - "$state_dir/current.json" <<'PY'
import json, os, sys
from pathlib import Path
destination = Path(sys.argv[1])
temporary = destination.with_suffix('.tmp')
data = {name.lower(): os.environ[name] for name in ('RELEASE_SHA', 'FRONTEND_IMAGE', 'BACKEND_IMAGE', 'DEPLOY_ENV')}
data['release_run_id'] = os.environ.get('RELEASE_RUN_ID', 'local')
data['deployment_run_id'] = os.environ.get('GITHUB_RUN_ID', 'local')
temporary.write_text(json.dumps(data, indent=2) + '\n')
temporary.replace(destination)
PY
echo "Deployment passed for $DEPLOY_ENV at $RELEASE_SHA."
