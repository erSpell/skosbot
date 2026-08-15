# Security Notes

Hermes Discord access is powerful. Authorized Discord users can interact with the full Hermes agent pipeline, including tools, local files, GitHub auth, terminal commands, skills, memory, and configured integrations.

## Minimum safe defaults

Use explicit allowlists:

```env
DISCORD_ALLOWED_USERS=your_discord_user_id
```

or role-based access in trusted servers:

```env
DISCORD_ALLOWED_ROLES=role_id
```

Do not set `DISCORD_ALLOW_ALL_USERS=true` unless the server is private/trusted and you understand the impact.

## Mention safety

Leave these defaults in place:

```env
DISCORD_ALLOW_MENTION_EVERYONE=false
DISCORD_ALLOW_MENTION_ROLES=false
DISCORD_ALLOW_MENTION_USERS=true
DISCORD_ALLOW_MENTION_REPLIED_USER=true
```

This prevents accidental `@everyone`, `@here`, or role pings from generated text.

## Bot-to-bot loops

Keep:

```env
DISCORD_ALLOW_BOTS=none
```

Do not wire multiple auto-replying Hermes bots together in the same channel/thread. Discord reply mentions can create loops.

## Secret handling

Never commit:

- Discord bot tokens
- GitHub tokens
- LLM provider API keys
- OAuth files or credential exports

Use `~/.hermes/.env`, Windows Credential Manager, a password manager, or deployment secrets.

## Shared channel sessions

Recommended:

```yaml
group_sessions_per_user: true
```

This keeps each user's session isolated inside shared Discord channels. Turn it off only for deliberate collaborative-room behavior.

## If a token leaks

1. Reset the token in Discord Developer Portal immediately.
2. Update `~/.hermes/.env` or your secret store.
3. Restart Hermes gateway.
4. Audit recent bot activity in server channels/logs.
