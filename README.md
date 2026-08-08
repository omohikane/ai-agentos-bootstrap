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

## Quickstart — on a vanilla VM you create yourself

Most setups start with any minimal Arch Linux VM (KVM / Proxmox / a cloud
provider) rather than our cloud-init template. cloud-init isn't needed for this
path — you make the VM, then pull this repo in over SSH.

1. **Create the VM** — boot a minimal Arch Linux image with a normal login user
   that can `sudo`, and reach it over SSH (initial access is whatever the
   provider/install image gives you).

2. **Clone this repo** on the VM (if `git` isn't pre-installed:
   `sudo pacman -S --needed git` first; give your user write access to `/opt`):

   ```
   sudo chown "$USER" /opt
   git clone https://github.com/<owner>/<repo>.git /opt/ai-agentos-bootstrap
   ```

3. **Set your user-level values** — see the index in [docs/user-edits.md](docs/user-edits.md):
   - `ansible/vars/main.yml` — git identity, hostname, timezone
   - `~/.env` — copy `ansible/secrets.env.example` and fill short-lived tokens
   - `ansible/vars/tools.list` / `ai-tools.list` — what to install

4. **Install the core toolchain** (git, ansible, yay, uv, rustup, fnm, openssh…):

   ```
   cd /opt/ai-agentos-bootstrap && ./bootstrap/bootstrap.sh
   ```

5. **Apply the config**:

   ```
   make provision
   ```

   base → tools → ai → security, fully idempotent. Repeat anytime after editing
   the files above.

6. **Make sure your SSH key is inside before step 5**. Provisioning makes
   sshd key-only and restricted to the agent user, so pass your public key in
   if the VM was never given one:

   ```
   mkdir -p ~/.ssh && chmod 700 ~/.ssh
   echo '<your-public-key>' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
   ```

7. **Run an agent**:

   ```
   run-agent opencode --auto "your first task"
   run-agent codex           # any tool enabled in ai-tools.list
   ```

   or enable the managed service (`systemctl start ai-agent`) for a persistent
   session.

### Running a single stage manually

If you only change one stage (or a first boot auto-run didn't finish), each can
be run on its own:

```
cd /opt/ai-agentos-bootstrap
./bootstrap/bootstrap.sh          # core toolchain only
make provision                    # Ansible self-apply only
make packages                     # packages only, on an already-built VM
```

## Quickstart — from our cloud-init template (no manual SSH steps)

For fully hands-off, repeatable VMs the repo includes a cloud-init template.
First boot runs cloud-init → `bootstrap.sh` → `make provision` automatically:

1. Build the template on an Arch host:

   ```
   sudo ./cloud-init/build-image.sh
   ```

2. Import the qcow2 into Proxmox / KVM and attach `cloud-init/user-data.example.yml`
   (username, SSH key, `.env`) and `cloud-init/meta-data.example.yml`.

3. Start the VM. It ends agent-ready with no manual login.

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
