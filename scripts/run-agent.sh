#!/usr/bin/env bash
set -euo pipefail

# run-agent.sh - entry point to run an AI agent on this VM.
#
# Usage:
#   run-agent <tool> [args...]
#
# Examples:
#   run-agent opencode --auto "refactor this repo"
#   run-agent codex
#   run-agent goose
#
# Loads ~/.env (injected by cloud-init) and the version-manager PATH from
# /etc/profile.d/ai-agent-env.sh before exec'ing the agent.

tool="${1:?usage: run-agent <tool> [args...]}"
shift

if [ -f "$HOME/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  . "$HOME/.env"
  set +a
fi

if [ -f /etc/profile.d/ai-agent-env.sh ]; then
  # shellcheck disable=SC1091
  . /etc/profile.d/ai-agent-env.sh
fi

case "$tool" in
  opencode) exec opencode "$@" ;;
  codex)    exec codex "$@" ;;
  goose)    exec goose "$@" ;;
  *)
    echo "unknown agent tool: $tool (opencode | codex | goose)" >&2
    exit 1
    ;;
esac