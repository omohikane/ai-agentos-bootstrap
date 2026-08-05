#!/usr/bin/env bash
set -euo pipefail

# bootstrap.sh - minimal core bootstrap for a vanilla Arch Linux VM.
#
# Fixed core install (keep simple; complex setup is delegated to Ansible):
#   - git        ... clone this repository
#   - base-devel ... required to build AUR packages (yay)
#   - ripgrep    ... fast OS-wide search for AI agents
#   - ansible    ... the configuration layer (make provision)
#   - python     ... runtime (uv manages project pythons)
#   - uv         ... fast Python package/version manager
#   - rustup     ... Rust toolchain manager (modern tools, build deps)
#   - openssh    ... key-only SSH access to the VM
#   - fnm        ... Node version manager (installs LTS Node)
#   - yay        ... AUR helper (built from source, idempotent)
#
# Works both as root (CI container) and as a regular sudo user (VM).
# Idempotent: safe to re-run.

log() { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$*"; }

if [ "$(id -u)" -eq 0 ]; then
  SUDO=()
else
  SUDO=(sudo)
fi

pacman_install() {
  "${SUDO[@]}" pacman -S --needed --noconfirm "$@"
}

log "install core packages"
pacman_install git base-devel ripgrep ansible python uv rustup openssh

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    log "yay already installed. skip."
    return
  fi
  log "build yay from AUR"
  local tmpdir builder
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"

  if [ "$(id -u)" -eq 0 ]; then
    pacman_install sudo
    builder="builder"
    id "$builder" >/dev/null 2>&1 || useradd -m "$builder"
    printf '%s ALL=(ALL) NOPASSWD:ALL\n' "$builder" > "/etc/sudoers.d/$builder"
    chown -R "$builder" "$tmpdir"
    ( cd "$tmpdir/yay" && runuser -u "$builder" -- makepkg -si --noconfirm )
  else
    ( cd "$tmpdir/yay" && makepkg -si --noconfirm )
  fi
}

install_fnm() {
  if command -v fnm >/dev/null 2>&1; then
    log "fnm already installed. skip."
    return
  fi
  log "install fnm (node version manager) via yay"
  yay -S --needed --noconfirm fnm
}

setup_env() {
  log "write shell env for version managers"
  "${SUDO[@]}" tee /etc/profile.d/ai-agent-env.sh >/dev/null <<'EOF'
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash)"
fi
EOF
}

install_toolchains() {
  log "install stable rust toolchain"
  rustup default stable
  log "install node lts via fnm"
  fnm install --lts || true
  fnm default lts-latest || true
}

install_yay
install_fnm
setup_env
install_toolchains

log "bootstrap done. next: make provision"
