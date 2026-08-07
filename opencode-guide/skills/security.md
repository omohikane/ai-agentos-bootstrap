---
description: Read before touching credentials, permissions, or production. Security boundaries, secret handling, and production-change rules.
---

# Security

## Security boundaries

Operate with the minimum privileges the task needs. Normal autonomous
development may include: reading the repo, modifying task files, running local
commands and tests, creating branches/commits, pushing task branches, creating
and merging validated PRs.

Never:

- expose, print, or log secrets or credentials,
- commit tokens or private keys, or put them in commit messages, PRs, or agent
  responses,
- disable security controls, bypass branch protection, or skip required CI,
- modify unrelated credentials,
- intentionally exfiltrate repository data.

Do not include secrets in source code, logs, or any output.

## Production changes

Source-code autonomy does not imply unrestricted production access. Do not
deploy to production or modify live infrastructure unless deployment is
explicitly part of the task and the repository workflow clearly supports it.
Prefer the repository-defined CI/CD over manual production modification. Never
invent production credentials or deployment procedures.

## If unsure

When a task looks like it touches credentials, permissions, trust boundaries,
or production, stop and re-check the boundaries above before acting. When in
doubt, prefer the least-privilege option that still completes the task.