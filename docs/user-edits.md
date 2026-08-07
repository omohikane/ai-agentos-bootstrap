# Files you (the user) edit

This project is fully declarative. Your main job is editing a small set of files
in this repository. On the VM, the clone lives at `/opt/ai-agentos-bootstrap`
— edit the same files there and re-run `make provision`.

Order: **Step 1 → Step 2** are per-VM; **Step 3** is what you touch most often.

## Step 3 — your everyday files

| Path (repo root) | Purpose | When to edit |
|---|---|---|
| `ansible/vars/tools.list` | General packages, one per line. `aur:` prefix → yay. | Add/remove CLI tools. **This is the main file.** |
| `ansible/vars/ai-tools.list` | AI agent tools (opencode / codex / goose), toggled by uncommenting. | Change which agents are installed/configured. |
| `ansible/vars/main.yml` | hostname, timezone, git identity, repo_url, git aliases/model. | Change system & git vars. |

## Step 1 — per-VM setup (`cloud-init/`)

| File | Purpose |
|---|---|
| `cloud-init/user-data.example.yml` | Login **username**, **SSH key**, and the `write_files` **`.env`** block (secrets). This is what your provider consumes. |
| `cloud-init/meta-data.example.yml` | VM hostname (optional). |

## Step 2 — secrets

| File | Purpose |
|---|---|
| `ansible/secrets.env.example` | Template for `~/.env` (copied into user-data). Fill with **short-lived tokens only**. |

## Step 4 — per-agent configs (advanced)

| Path | Purpose |
|---|---|
| `ansible/config/<tool>/…j2` | Jinja2 templates rendered to `~/.config/<tool>/`. Master settings. |

## How to apply

```
# on the VM, after login (or first boot does it automatically):
cd /opt/ai-agentos-bootstrap && make provision
```

Print this list anytime:

```
make show-editable
```