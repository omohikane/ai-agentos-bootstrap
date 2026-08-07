#!/usr/bin/env bash
set -euo pipefail

# show-editable-files.sh - print the files a user is expected to edit.

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
vm_path="/opt/ai-agentos-bootstrap"

cat <<'EOF'
Files a user edits (paths are relative to the repo root; on the VM prefix
them with /opt/ai-agentos-bootstrap):

  Everyday (your main files):
    ansible/vars/tools.list      ... general packages, one per line (Main!)
    ansible/vars/ai-tools.list   ... AI agents (opencode/codex/goose)  : toggle
    ansible/vars/main.yml        ... git identity, hostname, timezone, model

  Per-VM setup (cloud-init):
    cloud-init/user-data.example.yml  # username + SSH key + .env block
    cloud-init/meta-data.example.yml  # hostname

  Secrets:
    ansible/secrets.env.example       # -> ~/.env (short-lived tokens only)

  Advanced per-agent configs:
    ansible/config/<tool>/             # Jinja2 -> ~/.config/<tool>/

Details: docs/user-edits.md
EOF