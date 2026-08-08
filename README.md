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

1. **Prepare the template** — on an Arch host (the repo checkout), build the
   cloud-init qcow2:

   ```
   sudo ./cloud-init/build-image.sh
   ```

2. **Import & attach** — import the qcow2 into Proxmox / KVM as a template, then
   attach the cloud-init files:
   - `cloud-init/user-data.example.yml` — login username, **SSH key**,
     and the `.env` secrets block (short-lived tokens, see `ansible/secrets.env.example`)
   - `cloud-init/meta-data.example.yml` — hostname

3. **Start the VM** — first boot runs cloud-init → `bootstrap.sh` (core
   toolchain) → `make provision` (Ansible self-apply) and ends agent-ready,
   with no manual login required.

4. **Log in over SSH** (see `docs/usage.md` for a ready `~/.ssh/config` alias):
   ```bash
   ssh ai
   make ssh VM_HOST=ai      # same thing from a repo checkout
   ```

5. **Run an agent**:
   ```bash
   run-agent opencode --auto "your first task"
   run-agent codex           # any tool enabled in ai-tools.list
   ```
   or enable the managed service (`systemctl start ai-agent`) for a persistent
   session.

### Running a single stage manually

If first boot's auto-run didn't finish (or you changed a stage on an existing
VM), each stage can be run by itself:

```
# on the VM, in a clone of this repo:
./bootstrap/bootstrap.sh          # core toolchain only (git, ansible, uv, rustup, fnm, yay, …)
make provision                    # Ansible self-apply only (base → tools → ai → security)
make packages                     # packages only, on an already-built VM
```

For day-to-day usage, the rebuild recipe (treat the VM as disposable), and the
list of files you edit, see `docs/usage.md`, `docs/rebuild.md`, and
`docs/user-edits.md`.

## Where do I edit?

Your only edits are a few files. **[docs/user-edits.md](docs/user-edits.md)** is
the index that links to each of them (and each file links back). The short
version: `ansible/vars/tools.list`, `ansible/vars/ai-tools.list`,
`ansible/vars/main.yml`, and `cloud-init/user-data.example.yml`.

## Status

- [x] M0 skeleton (repository layout)
- [x] M1 cloud-init template build script
- [x] M2 bootstrap.sh (core toolchain + version managers)
- [x] M3 Ansible self-apply
- [x] M4 CI reproducibility checks
- [x] M5 AI autonomous execution environment (Phase 2)

## License

MIT
