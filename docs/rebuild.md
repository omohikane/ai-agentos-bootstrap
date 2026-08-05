# Rebuild recipe

The VM is intentionally disposable. Do not patch or upgrade in place; rebuild.

## When to rebuild

- The VM is broken (update regressions, `rm -rf` accidents, corrupt packages).
- You want a fresh agent environment (new tools, new config, new secrets).

## How to rebuild

1. Stop/destroy the VM (Proxmox: stop + remove the VM, keep the template).
2. Re-create the VM from the `arch-agent.qcow2` template.
3. Attach fresh user-data (username / SSH key / `.env`).
4. Start the VM. First boot re-runs cloud-init → bootstrap → provision automatically.

```bash
# build the template once (on an Arch build host)
sudo ./cloud-init/build-image.sh
```

## Running an agent

Manual (both supported, per design):

```bash
# one-shot autonomous run
run-agent opencode --auto "describe the task"

# or an interactive session
run-agent opencode
run-agent codex
run-agent goose
```

Autonomous service (Phase 2):

```bash
# write the prompt the agent should work on
echo "refactor the repo" > /opt/ai-agentos-bootstrap/agent-task.txt

# run once
systemctl start ai-agent
systemctl status ai-agent

# or run at every boot
systemctl enable --now ai-agent
```

`ai-agent` uses the default agent (`ai_agent_default`, currently `opencode`);
override by editing `ansible/vars/main.yml` and re-running `make provision`.

## Secrets after rebuild

Secrets live in the user-data `.env` (short-lived tokens). On rebuild, supply a
fresh `.env`; never reuse long-lived credentials on a disposable VM.