#!/usr/bin/env bash
set -euo pipefail
base_url="${1:-http://127.0.0.1:8088}"
curl --fail --silent --show-error --retry 12 --retry-connrefused --retry-delay 5 "$base_url/healthz" >/dev/null
curl --fail --silent --show-error "$base_url/" | grep -q '<title>IAM Platform</title>'
curl --fail --silent --show-error "$base_url/api/health" | python3 -c 'import json,sys; assert json.load(sys.stdin)["status"] == "UP"'
status="$(curl --silent --show-error --output /dev/null --write-out '%{http_code}' "$base_url/api/employees")"
test "$status" = 403
echo 'Smoke checks passed: portal, reverse proxy, backend health, and access denial.'
