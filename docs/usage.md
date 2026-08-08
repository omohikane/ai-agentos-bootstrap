# Usage

Your everyday workflow comes down to editing two files and (occasionally) running
`make provision`. The VM is treated as disposable: rebuild instead of maintaining.

## The files you edit

### 1. `ansible/vars/tools.list` — general tools

One package per line, installed via pacman (or via yay when prefixed `aur:`).
Lines starting with `#` are comments.

```
# example
tmux
neovim
jq
aur:some-aur-package
```

### 2. `ansible/vars/ai-tools.list` — AI agent tools (opt-in)

Uncomment a line to give that agent a configured environment. Installed via yay
by default, or via the official installer where that is clearly preferred.

```
opencode
# goose
# codex
```

## Building and running a VM

### Step 1: build the cloud-init image

(Implemented in M1.)

```
make build-image
```

This produces a cloud-init-enabled qcow2. Import it into Proxmox / KVM as a
template. See `docs/architecture.md` for the reference stack (4 vCPU / 8 GB RAM /
64 GB disk is the recommended starting point).

### Step 2: configure the VM (user-data)

Edit `cloud-init/user-data.example.yml`:

- username
- SSH public key (`ssh_authorized_keys`)
- secrets under the `write_files` block, following `ansible/secrets.env.example`

`ssh_pwauth` is disabled after first boot — SSH key is the only way in.

### Step 3: first boot

cloud-init creates the user, installs git, clones this repository, runs
`bootstrap.sh`, then `make provision` — ending in an agent-ready state with no
manual login required.

If anything failed, log in with the SSH key and run manually:

```
/opt/ai-agentos-bootstrap/bootstrap/bootstrap.sh
cd /opt/ai-agentos-bootstrap && make provision
```

### Step 4: run an agent (Phase 2)

Start any enabled agent, e.g.:

```
opencode --auto "<task>"
```

or claude code / codex. Agent starter scripts (systemd service or one-shot) are
provided in Phase 2.

## Connecting over SSH (you, from your laptop)

The VM is built to be reached over SSH and treated as disposable. It is
configured for key-only login, and `make provision` adds keepalive and restricts
logins to the agent user, so long agent jobs survive network moves.

One-time client convenience: add an alias in `~/.ssh/config` on **your laptop**:

```
Host ai
    HostName <vm-ip-or-name>
    User <your-agent-login-user>
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    IdentitiesOnly yes
    ControlMaster auto
    ControlPath ~/.ssh/ctrl:%h:%p
    ControlPersist 5m
```

`ServerAliveInterval` keeps the session alive across quiet periods; `Control*`
reuse the first connection, so repeated `make` / agent runs reconnect instantly.

Then either connect directly or through the Makefile:

```
ssh ai
make ssh VM_HOST=ai
```

Agent terminals can also be (re)claimed from anywhere via `herdr` (installed on
the VM) — it survives client drops entirely.

## Secrets

`ansible/secrets.env.example` is the template for a `.env` file that cloud-init
injects into the VM (`~/.env`). Because the VM is disposable, use short-lived
tokens (e.g. temporary API keys) so that a leak is low-impact. Avoid long-lived,
restricted credentials.

## Rebuild recipe

The VM is intentionally thrown away rather than patched.

1. Stop/destroy the VM.
2. Re-create it from the qcow2 template with fresh user-data.
3. On first boot everything is re-provisioned automatically.

## Reference

- `docs/architecture.md` — design and rationale