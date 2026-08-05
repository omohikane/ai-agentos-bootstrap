#!/usr/bin/env bash
set -euo pipefail

# bootstrap.sh - バニラ Arch への最小 core 導入
#
# 固定で導入するもの (シンプルに固定し、複雑な設定は Ansible に任せる):
#   - git          … リポジトリ取得
#   - base-devel   … AUR (yay) のビルドに必要
#   - ripgrep      … AI agent が OS 内で高速検索するために導入
#   - ansible      … 以降の設定自動化 (make provision)
#   - yay          … AUR helper (build して導入)
#
# 以降の設定は Ansible が行います: make provision

log() { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$*"; }

log "install core packages: git, base-devel, ripgrep, ansible"
sudo pacman -S --needed --noconfirm git base-devel ripgrep ansible

if command -v yay >/dev/null 2>&1; then
  log "yay already installed. skip."
else
  log "build yay from AUR"
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (
    cd "$tmpdir/yay"
    makepkg -si --noconfirm
  )
fi

log "bootstrap done. next: make provision"
