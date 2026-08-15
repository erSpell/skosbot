# skosbot Architecture

skosbot is an interface layer, not a standalone AI implementation.

## Runtime flow

```text
Discord user message
  ↓
Discord gateway event
  ↓
Hermes gateway Discord adapter
  ↓
Authorization and routing
  ↓
Hermes session lookup/load
  ↓
Hermes Agent run
  ↓
Tools / memory / skills / model provider
  ↓
Discord response delivery
```

## Components

### Discord application

The Discord Developer Portal application owns:

- Application ID
- Bot user
- Bot token
- Invite/install URL
- Gateway intent toggles
- Slash command registration

### Discord bot token

The bot token lets Hermes gateway connect as the Discord bot. Treat it like a password.

It belongs in:

```text
~/.hermes/.env
```

not in this repo.

### Hermes gateway

The gateway is the bridge between Discord and Hermes Agent. It is responsible for:

- Connecting to Discord Gateway/WebSocket
- Receiving messages and attachments
- Enforcing `DISCORD_ALLOWED_USERS`, roles, or channel access
- Handling mention/free-response rules
- Loading the correct Hermes session
- Sending responses back to Discord

### Hermes Agent profile

The agent profile provides the actual capability:

- Model/provider settings
- Terminal/file/browser/tool access
- Skills
- Memory
- GitHub auth and other integrations
- Cron/proactive delivery if configured

## Session model

Recommended default:

```yaml
group_sessions_per_user: true
```

That means users in the same Discord channel get separate Hermes session histories. This is safer for shared servers because one user's context, costs, and in-flight tasks do not leak into another user's session.

For a deliberate collaborative room, set it to `false`, but expect shared history and shared interruption behavior.

## Channel behavior

Recommended initial posture:

- Require `@mention` in server channels.
- Allow normal response in DMs.
- Use `DISCORD_FREE_RESPONSE_CHANNELS` only for a dedicated private skosbot channel.
- Keep auto-threading enabled for mentioned channel conversations.

## What skosbot does not do

- It does not run a Discord user account/self-bot.
- It does not replace Hermes Agent.
- It does not store secrets in git.
- It does not support bot-to-bot auto-reply loops.
