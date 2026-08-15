# Discord Setup Checklist

## 1. Create Discord application

1. Open <https://discord.com/developers/applications>.
2. Click **New Application**.
3. Name it, for example `Hermes Agent`.
4. Save the **Application ID** for invite URL generation.

## 2. Create/configure bot

1. Go to **Bot** in the app sidebar.
2. Customize name/avatar if desired.
3. Under **Privileged Gateway Intents**, enable:
   - **Message Content Intent**
   - **Server Members Intent**
4. Click **Save Changes**.
5. Reset/copy the bot token. It is only shown once.

## 3. Invite bot to server

Generate an invite URL:

```bash
bash scripts/generate_invite_url.sh YOUR_APPLICATION_ID
```

Open the URL, select your server, and authorize.

You need **Manage Server** permission in the target Discord server.

## 4. Find Discord IDs

Enable Developer Mode in Discord:

1. User Settings → Advanced → Developer Mode ON.
2. Right-click your profile → Copy User ID.
3. Optional: right-click channel/server/role → Copy ID.

## 5. Configure Hermes

Use the guided setup:

```bash
hermes gateway setup
```

Or manually merge `.env.example` into `~/.hermes/.env`:

```env
DISCORD_BOT_TOKEN=
DISCORD_ALLOWED_USERS=
```

Fill those values only in your local `~/.hermes/.env` or deployment secret store.

Optional config defaults live in `config/discord.config.yaml`.

## 6. Verify

```bash
bash scripts/doctor.sh
```

## 7. Start

Foreground:

```bash
hermes gateway run
```

If gateway is installed as a service:

```bash
hermes gateway restart
hermes gateway status
```

## 8. Test behavior

- DM the bot: it should answer every allowed DM.
- In a server channel: `@mention` it by default.
- In an auto-created thread: continue talking normally.

If it is online but silent, re-check Message Content Intent and `DISCORD_ALLOWED_USERS`.
