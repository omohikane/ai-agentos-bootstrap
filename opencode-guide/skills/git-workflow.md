---
description: Read before any git operations. Covers the task branch model, protected branches, commits, PRs, automatic merge, squash, worktrees, force-push, and the default git workflow.
---

# Git workflow

## Task model

Default model:

```
1 independently reviewable task = 1 short-lived task branch = 1 pull request
```

Branch names:

```text
agent/<issue-id>-<short-description>   # e.g. agent/123-login-rate-limit
agent/<short-description>              # when no issue id exists
```

Create the task branch from the intended PR target branch — usually `main` —
but follow repository conventions.

## Never develop directly on protected branches

Do not perform normal development directly on `main`, `master`, `develop`, or
other protected integration branches. Use a dedicated task branch. Do not
bypass branch protection; do not disable repository protections to make a task
easier.

## Default git workflow

```text
receive task -> inspect repo -> decompose -> create task branch
-> delegate/implement -> test + lint + build -> review final diff
-> commit -> push task branch -> create/update PR
-> required CI -> merge -> delete task branch
```

Do not leave completed work stranded in an unpushed local branch.

## Commit strategy

- Do not optimise for a specific commit count. Commit whenever it improves
  recoverability, logical separation, debugging, or collaboration. Checkpoint
  commits are allowed.
- Prefer coherent commits that follow the repo convention, or Conventional
  Commits when the repo has none: `feat`, `fix`, `refactor`, `test`, `docs`,
  `chore`, `build`, `ci`, `perf`.
- Avoid meaningless history: `fix`, `fix2`, `oops`, `tmp`, `stuff`, `update`.
- A task branch may contain multiple reasonable commits.
- With Squash Merge, the target branch normally receives one clean commit per
  task.
- Commit messages describe the actual change, not the agent's thought process.

- Prefer coherent commits (conventional prefixes when the repo has none):
  `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`, `ci`, `perf`.
- Avoid meaningless history: `fix`, `fix2`, `tmp`, `oops`, `update`.
- A task branch may contain multiple reasonable commits.
- With Squash Merge, the target branch normally receives one clean commit per
  task.
- Commit messages describe the actual change, not the agent's thought process.

## PR + automatic merge

Create or update the PR automatically when the task is ready. The PR body
should describe: what changed, why, important decisions, tests performed, and
known limitations. Do not document every intermediate thought. Human approval
is not required by default: merge automatically when the implementation is
complete, required tests and CI pass, protections are satisfied, no conflicts
remain, and no known task-related failures remain. Never bypass required
checks. Prefer Squash Merge unless the repository specifies otherwise. After
merging, delete the completed task branch when policy permits.

## Recoverability rules

- Respect local Git hooks. Do not routinely bypass them with `--no-verify`.
- Before destructive operations, inspect the repository state (branch,
  uncommitted/untracked files, existing worktrees/branches). Never destroy
  work you did not create.
- Avoid `git reset --hard`, `git clean -fd`, `git checkout -- .`,
  `git restore .`, and `git push --force` unless genuinely necessary and
  scoped only to the current task.
- Force-push is off by default. If rewriting your own task branch is genuinely
  useful and only you own it, prefer `git push --force-with-lease`. Never
  rewrite shared or protected history.

## Worktree isolation

Use separate Git worktrees when multiple agents need independent writable
working environments:

```text
repository/
worktrees/
├── task-101/
├── task-102/
└── task-103/
```

Each concurrent writable agent should have its own worktree and branch. Never
let multiple agents modify the same working tree concurrently.

## Conflict resolution

When integrating parallel work: understand both changes, preserve the intended
behaviour of each, resolve semantically, and run the relevant tests afterwards.
Do not resolve a conflict by wholesale choosing one side unless that is clearly
correct.