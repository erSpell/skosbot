#!/usr/bin/env bash
set -euo pipefail

APP_ID="${1:-}"
PERMISSIONS="${DISCORD_INVITE_PERMISSIONS:-274878286912}"

if [[ -z "$APP_ID" ]]; then
  echo "Usage: bash scripts/generate_invite_url.sh <discord_application_id>" >&2
  exit 2
fi

if ! [[ "$APP_ID" =~ ^[0-9]+$ ]]; then
  echo "Application ID should be numeric. Got: $APP_ID" >&2
  exit 2
fi

printf 'https://discord.com/oauth2/authorize?client_id=%s&scope=bot+applications.commands&permissions=%s\n' "$APP_ID" "$PERMISSIONS"
