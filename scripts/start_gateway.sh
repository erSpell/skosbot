#!/usr/bin/env bash
set -euo pipefail

if ! command -v hermes >/dev/null 2>&1; then
  echo "hermes command not found. Install/setup Hermes first." >&2
  exit 1
fi

exec hermes gateway run
