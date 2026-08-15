# skosbot

**skosbot** is a small operations/configuration repo for using **Discord as an interface to Hermes Agent**.

It does not implement a separate AI bot brain and it is not a Discord self-bot. Discord provides the chat surface, a Discord Bot Token authenticates the gateway, and Hermes Agent does the actual reasoning, tool use, memory, skills, and automation.

## Purpose

skosbot exists to make this workflow repeatable:

```text
You in Discord
  → DM / @mention skosbot
  → Discord Bot Gateway
  → local Hermes Agent profile
  → tools, files, terminal, GitHub, skills, memory
  → response back in Discord
```

## What this repo contains

- Safe Discord/Hermes environment template: [`.env.example`](.env.example)
- Hermes Discord config defaults: [`config/discord.config.yaml`](config/discord.config.yaml)
- Setup checklist: [`docs/setup.md`](docs/setup.md)
- Architecture notes: [`docs/architecture.md`](docs/architecture.md)
- Operations/runbook notes: [`docs/operations.md`](docs/operations.md)
- Security notes: [`docs/security.md`](docs/security.md)
- Helper scripts:
  - [`scripts/doctor.sh`](scripts/doctor.sh) — checks local Hermes/Discord gateway config
  - [`scripts/generate_invite_url.sh`](scripts/generate_invite_url.sh) — builds the Discord bot invite URL
  - [`scripts/start_gateway.sh`](scripts/start_gateway.sh) — starts Hermes gateway in the foreground

## Quick start

1. Create a Discord Application and Bot in the Discord Developer Portal.
2. Enable these privileged intents on the Bot page:
   - Message Content Intent
   - Server Members Intent
3. Copy the bot token.
4. Copy your Discord User ID with Developer Mode enabled.
5. Merge `.env.example` into your Hermes env file and fill in values:

   ```bash
   cp .env.example ~/.hermes/.env
   ```

   If `~/.hermes/.env` already exists, merge the Discord variables manually instead of overwriting it.

6. Generate an invite URL with your Discord Application ID:

   ```bash
   bash scripts/generate_invite_url.sh YOUR_APPLICATION_ID
   ```

7. Run the local check:

   ```bash
   bash scripts/doctor.sh
   ```

8. Start the gateway:

   ```bash
   hermes gateway run
   ```

## Default behavior

- DMs: skosbot responds to every allowed DM.
- Server channels: skosbot responds when mentioned.
- Threads: skosbot replies in the same thread.
- Shared channels: session history is isolated per user by default.
- Other bots: ignored by default to avoid loops.

## Info still needed before live deployment

The scaffold is generic. To actually bring skosbot online, you need to provide/configure:

- Discord Application ID
- Discord Bot Token
- Your Discord User ID
- Target server/channel IDs, if using home/free-response channels
- Whether the gateway should run foreground, as a Windows scheduled task, or on another host

## Publishing note

Do not commit real tokens. Keep secrets only in `~/.hermes/.env`, Windows Credential Manager, a password manager, or your deployment secret store.
