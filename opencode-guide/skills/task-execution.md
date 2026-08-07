---
description: Read for any non-trivial task before editing. Covers understanding the request, decomposing work, keeping changes scoped, preserving existing work, and the Definition of Done.
---

# Task execution

## 1. Understand before editing
1. Inspect the relevant code and nearby implementations.
2. Inspect project documentation and repository-specific instructions.
3. Identify relevant tests and the build/validation commands.
4. Understand the expected scope of the task.
5. Follow existing conventions unless the task explicitly requires changing them.

Prefer existing abstractions, libraries, helper functions, architectural
patterns, error-handling and naming conventions. Do not introduce unnecessary
architecture for the sake of a theoretically cleaner design.

## 2. Decompose complex tasks
Do not treat a large request as one monolithic operation. Break work into small,
independently understandable units. A good unit:

- one clear purpose,
- explicit completion criteria,
- independently testable where practical,
- touches only related parts of the system,
- produces a reviewable diff.

Example:

```text
Implement authentication improvements
    +-- investigate current authentication flow
    +-- add validation tests
    +-- implement validation logic
    +-- update API behaviour
    +-- run regression tests
    +-- review final diff
```

Genuinely independent features → separate tasks/branches where appropriate.
Do not silently turn one task into a large unrelated refactor.

## 3. Keep changes scoped
Modify only what is relevant. Do not perform unrelated formatting, renaming,
dependency upgrades, cleanup, refactoring, or documentation rewrites. Small
incidental improvements are acceptable only when directly required. If you
discover unrelated technical debt, leave it alone unless resolving it is
necessary for the current task.

## 4. Preserve existing work
Before destructive Git operations, inspect: current branch, uncommitted
changes, untracked files, existing worktrees, existing agent branches. Do not
destroy changes you did not create. Avoid `git reset --hard`, `git clean -fd`,
`git checkout -- .`, `git restore .`, `git push --force` unless genuinely
necessary and scoped only to work owned by the current task. Prefer recoverable
operations.

## 5. Definition of Done
A task is complete only when, as applicable:

- behaviour is implemented and matches repo conventions,
- the change remains scoped,
- relevant tests exist and pass, lint / type check / build pass,
- required CI passes and the final diff was reviewed,
- no secrets or temporary artefacts were introduced,
- commits are understandable,
- the PR accurately describes the work,
- integration completed successfully.

Writing code alone does not make the task done.