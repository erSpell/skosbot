# skosbot Operations

## Local check

Run:

```bash
bash scripts/doctor.sh
```

Expected before Discord is configured:

- Hermes command exists.
- Git exists.
- Missing `DISCORD_BOT_TOKEN` is reported.
- Missing access policy is reported.

Expected after Discord is configured:

- `DISCORD_BOT_TOKEN` is present.
- At least one access policy is present:
  - `DISCORD_ALLOWED_USERS`
  - `DISCORD_ALLOWED_ROLES`
  - `DISCORD_ALLOWED_CHANNELS`
  - explicit `DISCORD_ALLOW_ALL_USERS=true`

## Start foreground

```bash
bash scripts/start_gateway.sh
```

Equivalent:

```bash
hermes gateway run
```

Use foreground mode while testing because logs are immediately visible.

## Install/start as service

On Windows, Hermes can install the gateway as a scheduled task:

```bash
hermes gateway install
hermes gateway start
hermes gateway status
```

Restart after changing `.env` or relevant config:

```bash
hermes gateway restart
```

## Check logs

Gateway logs usually live under:

```text
~/.hermes/logs/
```

Useful check:

```bash
grep -i "discord\|error\|failed\|intent\|allowed" ~/.hermes/logs/gateway.log | tail -80
```

## Common problems

### Bot is online but silent

Likely causes:

- Message Content Intent is disabled.
- `DISCORD_ALLOWED_USERS` / roles / channel policy does not include you.
- You are speaking in a server channel without mentioning the bot.
- Bot lacks channel permissions.

### Bot cannot read channel

Check Discord channel permissions for the bot role:

- View Channel
- Send Messages
- Read Message History
- Attach Files
- Embed Links
- Send Messages in Threads, if using threads

### Bot loops or responds to other bots

Keep:

```env
DISCORD_ALLOW_BOTS=none
```

Do not let multiple auto-replying Hermes bots mention/reply to each other.

## Deployment decision points

Before making skosbot always-on, decide:

- Where it runs: this Windows machine, another desktop, server, or VM.
- Startup mode: foreground for testing, scheduled task/service for normal use.
- Discord access policy: user IDs vs role IDs.
- Channel policy: mention-only vs a dedicated free-response channel.
- Home channel: whether cron/proactive notifications should post to Discord.
