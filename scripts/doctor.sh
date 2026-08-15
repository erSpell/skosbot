#!/usr/bin/env bash
set -euo pipefail

HERMES_ENV="${HERMES_HOME:-$HOME/.hermes}/.env"
CONFIG_FILE="${HERMES_HOME:-$HOME/.hermes}/config.yaml"
failures=0

section() { printf '\n== %s ==\n' "$1"; }
check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    printf 'ok: %s -> %s\n' "$1" "$(command -v "$1")"
  else
    printf 'missing: %s\n' "$1"
    failures=$((failures + 1))
  fi
}
mask_value() {
  local value="$1"
  if [[ -z "$value" ]]; then
    printf '<empty>'
  elif ((${#value} <= 8)); then
    printf '********'
  else
    printf '%s...%s' "${value:0:4}" "${value: -4}"
  fi
}
get_env_value() {
  local key="$1"
  if [[ -f "$HERMES_ENV" ]]; then
    grep -E "^${key}=" "$HERMES_ENV" | tail -n 1 | cut -d= -f2- || true
  fi
}

section "Commands"
check_cmd hermes
check_cmd git

section "Hermes files"
printf 'HERMES_HOME=%s\n' "${HERMES_HOME:-$HOME/.hermes}"
if [[ -f "$HERMES_ENV" ]]; then
  printf 'ok: env file exists: %s\n' "$HERMES_ENV"
else
  printf 'missing: env file: %s\n' "$HERMES_ENV"
  failures=$((failures + 1))
fi
if [[ -f "$CONFIG_FILE" ]]; then
  printf 'ok: config file exists: %s\n' "$CONFIG_FILE"
else
  printf 'warn: config file not found: %s\n' "$CONFIG_FILE"
fi

section "Discord env"
for key in DISCORD_BOT_TOKEN DISCORD_ALLOWED_USERS DISCORD_ALLOWED_ROLES DISCORD_FREE_RESPONSE_CHANNELS DISCORD_HOME_CHANNEL; do
  value="$(get_env_value "$key")"
  if [[ -n "$value" ]]; then
    printf '%s=%s\n' "$key" "$(mask_value "$value")"
  else
    case "$key" in
      DISCORD_BOT_TOKEN)
        printf 'missing required: %s\n' "$key"
        failures=$((failures + 1))
        ;;
      DISCORD_ALLOWED_USERS|DISCORD_ALLOWED_ROLES)
        printf 'not set: %s\n' "$key"
        ;;
      *)
        printf 'optional not set: %s\n' "$key"
        ;;
    esac
  fi
done

allowed_users="$(get_env_value DISCORD_ALLOWED_USERS)"
allowed_roles="$(get_env_value DISCORD_ALLOWED_ROLES)"
allow_all="$(get_env_value DISCORD_ALLOW_ALL_USERS)"
allowed_channels="$(get_env_value DISCORD_ALLOWED_CHANNELS)"
if [[ -z "$allowed_users" && -z "$allowed_roles" && "$allow_all" != "true" && -z "$allowed_channels" ]]; then
  printf 'missing access policy: set DISCORD_ALLOWED_USERS, DISCORD_ALLOWED_ROLES, DISCORD_ALLOWED_CHANNELS, or explicit DISCORD_ALLOW_ALL_USERS=true\n'
  failures=$((failures + 1))
fi

section "Gateway status"
if command -v hermes >/dev/null 2>&1; then
  hermes gateway status || true
fi

section "Result"
if ((failures == 0)); then
  echo "ok: basic configuration checks passed"
else
  echo "failed: $failures issue(s) found"
  exit 1
fi
