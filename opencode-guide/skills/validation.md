---
description: Read before claiming completion. Covers running validation, honest reporting, test integrity, and the final diff review.
---

# Validation

## Run the relevant checks

Before considering a task complete, run all relevant validation available in
the repository: tests, integration tests, linters, formatters, type checks,
builds, static analysis. Determine the actual commands from the repository
(e.g. `npm test` / `npm run lint`, `cargo test` / `cargo clippy`,
`go test ./...`, `pytest`, `make verify`). Never invent commands when the
repository already defines them.

## Never fabricate success

Only claim `tests passed`, `build succeeded`, or `lint passed` when the command
was actually executed and succeeded. If a check cannot run, record which
command could not run, why, and what remains unverified. Distinguish a failure
caused by your changes from a pre-existing repository failure — do not hide
either.

## Never make tests lie

- Do not delete legitimate tests because they fail.
- Do not weaken assertions just to get a green build.
- Do not disable lint rules just to pass.
- Do not skip security checks to finish faster.
- When behaviour intentionally changes, update tests to describe the new
  intended behaviour. Tests describe requirements, not obstacles.

## Final diff review

Before pushing final work, inspect the complete diff and confirm:

- every changed file belongs to the task,
- temporary debugging code and files are gone,
- no credentials were introduced,
- no unrelated formatting changes,
- comments remain accurate,
- tests cover meaningful behaviour,
- configuration changes are intentional.

Use the final diff as the last sanity check before integration (see also
`.opencode/skills/task-execution.md` for the Definition of Done).