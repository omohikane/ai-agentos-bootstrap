# ai-agentos-bootstrap

> Working title. The repository name may change before the first public release.

An open-source bootstrap kit for building **AI-agent-ready VMs**.

It boots a **vanilla Arch Linux** VM (KVM / Proxmox / Hyper-V) from a cloud-init
template, installs a minimal core toolchain with `bootstrap.sh`, then applies
**Ansible to localhost (self-apply)** to provision packages and configuration.

## Concept

- **Vanilla layer = cloud-init template**: only a username and SSH key are injected;
  the VM boots into a login-ready state.
- **bootstrap.sh**: fixed, minimal core install only — `git`, `base-devel`,
  `ripgrep`, `ansible`, `python`, `uv`, `rustup`, `fnm` (Node), and `yay`.
- **Ansible self-apply**: run on first boot (or manually) to provision packages,
  AI agent tools, dotfiles, and security settings. Idempotent.
- **The user's main task is editing two files**:
  - `ansible/vars/tools.list` — general tools (one package per line)
  - `ansible/vars/ai-tools.list` — AI agent tools to enable (comment toggles)

## Flow

```
[1] cloud-init template (qcow2) imported into Proxmox / KVM
    -> username + SSH key injected, VM boots login-ready
[2] bootstrap.sh: core toolchain (git, base-devel, ripgrep, ansible,
    python, uv, rustup, fnm, yay)
[3] Ansible self-apply (auto on first boot, or manually via make provision):
    base -> tools -> ai -> security
[4] (Phase 2) AI agents (opencode / claude code / codex, ...) ready to run
```

## Repository layout

```
├── cloud-init/   … qcow2 template build + user-data/meta-data examples
├── bootstrap/    … minimal core install for vanilla Arch (shell script)
├── ansible/      … configuration automation (base / tools / ai / security)
│   ├── vars/     … tools.list / ai-tools.list (user-editable)
│   └── config/   … per-agent dotfile templates
└── docs/         … architecture / usage
```

## Quickstart

1. Build the template on an Arch host: `sudo ./cloud-init/build-image.sh`
2. Import the qcow2 into Proxmox / KVM and attach `cloud-init/user-data.example.yml`
   (username, SSH key, `.env`) + `cloud-init/meta-data.example.yml`.
3. Start the VM. First boot runs cloud-init → `bootstrap.sh` → `make provision`.
4. Log in with the SSH key and run an agent, e.g.:
   `run-agent opencode --auto "your task"` (or `systemctl start ai-agent`).

See `docs/usage.md` and `docs/rebuild.md` for details.

## Status

- [x] M0 skeleton (repository layout)
- [x] M1 cloud-init template build script
- [x] M2 bootstrap.sh (core toolchain + version managers)
- [x] M3 Ansible self-apply
- [x] M4 CI reproducibility checks
- [x] M5 AI autonomous execution environment (Phase 2)

## License

MIT
