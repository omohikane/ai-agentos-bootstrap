# Files you (the user) edit

This project is fully declarative. Your main job is editing a small set of files
in this repository. On the VM, the clone lives at `/opt/ai-agentos-bootstrap`
— edit the same files there and re-run `make provision`.

Order: **Step 0** is set-once; **Steps 1–2** are per-VM; **Step 3** is what you
touch most often. Every file links back to this page, and each row here links
to its file.

## Step 0 — set once: GitHub identity + agent keys

Do this before your first provision; both are plain-text edits.

1. **GitHub identity** — set `git_user_name` / `git_user_email` in
   [ansible/vars/main.yml](../ansible/vars/main.yml) to the identity you want
   on commits (gitconfig is system-wide, so every repo on the VM uses it).
2. **Per-agent API keys** — issue a **separate, short-lived key per agent**
   (opencode / codex / goose) for each provider you enable; revoking one
   doesn't break the others. Fill [ansible/secrets.env.example](../ansible/secrets.env.example),
   then put the contents into the `write_files` `.env` block of
   [cloud-init/user-data.example.yml](../cloud-init/user-data.example.yml).
   For GitHub, add a fine-grained `GH_TOKEN` (repo scope, days-long expiry) —
   the VM is disposable, so short scope + short life is the point. Never commit
   a filled .env.

## Step 1 — per-VM setup (`cloud-init/`)

| File | Purpose |
| --- | --- |
| [cloud-init/user-data.example.yml](../cloud-init/user-data.example.yml) | Login **username**, **SSH key**, and the `write_files` **`.env`** block (secrets). This is what your provider consumes. |
| [cloud-init/meta-data.example.yml](../cloud-init/meta-data.example.yml) | VM hostname (optional). |

## Step 2 — secrets

| File | Purpose |
| --- | --- |
| [ansible/secrets.env.example](../ansible/secrets.env.example) | Template for `~/.env` (copied into user-data). Fill with **short-lived tokens only**, one key per agent/provider. |

## Step 3 — your everyday files

| Path | Purpose | When to edit |
|---|---|---|
| [ansible/vars/tools.list](../ansible/vars/tools.list) | General packages, one per line. `aur:` prefix → yay. | Add/remove CLI tools. **This is the main file.** |
| [ansible/vars/ai-tools.list](../ansible/vars/ai-tools.list) | AI agent tools (opencode / codex / goose), toggled by uncommenting. | Change which agents are installed/configured. |
| [ansible/vars/main.yml](../ansible/vars/main.yml) | hostname, timezone, git identity, repo_url, model. | Change system & git vars. |

## Step 4 — per-agent configs (advanced)

| Path | Purpose |
| --- | --- |
| [ansible/config/](../ansible/config/README.md) | Jinja2 templates under `config/<tool>/`, rendered to `~/.config/<tool>/`. Master settings. |

## How to apply

```
# on the VM, after login (or first boot does it automatically):
cd /opt/ai-agentos-bootstrap && make provision
```

Print this list anytime (with file paths):

```
make show-editable
```