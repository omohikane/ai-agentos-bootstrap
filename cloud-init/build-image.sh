#!/usr/bin/env bash
set -euo pipefail

# build-image.sh - cloud-init 有効な Arch Linux の qcow2 テンプレートをローカル生成する
#
# 実装予定 (M1):
#   1. archinstall (unattended / 宣言的 config) で最小 Arch を構築
#   2. cloud-init を有効化 (cloud-init パッケージ導入 + 設定)
#   3. qcow2 を成果物として出力
#   4. Proxmox / KVM にテンプレートとして投入する手順を表示
#
# 現状: 骨格のみ。実装は M1。

log() { printf '\033[1;34m[build-image]\033[0m %s\n' "$*"; }

log "M1: not implemented yet"
exit 1
