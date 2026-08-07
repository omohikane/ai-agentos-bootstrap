---
description: Read when a task is non-trivial, investigation-heavy, or parallelizable. Covers delegation, parent/subagent responsibilities, parallelism, context isolation, conflict avoidance, failure handling, and independent review.
---

# Subagents

Subagents are a normal part of the workflow, not a last resort. Delegate
whenever it improves speed, context isolation, code quality, review quality,
investigation depth, or parallelism. Avoid doing everything in the parent
merely because you can. Avoid delegating when the task is so small that
coordination would cost more than execution.

## Parent agent responsibilities

The parent is the coordinator and owns: overall task interpretation,
decomposition, delegation, architectural consistency, final integration, final
validation, the main task branch history, PR creation, and merge decisions.
Maintain awareness of the complete task even when implementation is delegated.
Never blindly accept subagent output — review and integrate it.

## Subagent responsibilities

Give each subagent a narrow, explicit objective. It must be able to answer:

- What exactly am I responsible for?
- What files or subsystem am I investigating?
- What output should I return?
- What must I avoid changing?

Delegate by responsibility, not vague commands.

Good: "Analyse the authentication middleware and identify where expired JWTs
are handled. Do not modify files. Return file paths, behaviour, and suggested
fix points."

Good: "Implement unit tests for login rate limiting. Limit changes to the auth
test suite. Return the files changed and test results."

Avoid: "Look around and improve authentication."

Subagents must remain within their assigned scope.

## Parallelise independent work

Run independent investigations or implementations concurrently. After results
return, the parent synthesises findings, chooses an implementation, integrates,
and validates. Do not parallelise work that modifies the same files without
proper isolation. Avoid creating unnecessary merge conflicts.

Typical structure:

```text
Task --> Parent Agent --+--> Explorer Agent
                        +--> Test Agent
                        +--> Implementation Agent
                        +--> Review Agent
                        +--> Security Agent
```

## Protect context

Use subagents when a task requires large amounts of investigation that would
otherwise pollute the parent's context: searching large repositories,
analysing generated code, reading many config files, comparing implementations,
examining logs, tracing call graphs. The parent should receive concise findings
rather than every intermediate detail. Treat subagents as context-isolation
boundaries as well as parallel workers.

## Specialist subagents on demand

Roles do not need to be permanent; create them per task. Examples: Explorer
(understand architecture), Implementer (narrow scope change), Tester (create
tests), Debugger (investigate failures), Reviewer (inspect the diff),
Security Reviewer (trust boundaries, secrets, injection, permissions).

## Avoid agent conflicts

Determine expected file ownership before delegating writable work. Prefer
disjoint ownership:

```
Subagent A: src/auth/*
Subagent B: tests/auth/*
Subagent C: documentation only
```

When agents must touch overlapping code, serialise the work or have one agent
implement and another review. Parallelism is only useful when its coordination
cost stays below the saved work.

## Subagent Git strategy

- Read-only investigation: no branch needed.
- Small delegated change: subagent edits in an isolated work tree; parent
  integrates and commits.
- Independent unit: subagent may use a temporary child branch (for example
  `agent/123-tests`, `agent/123-implementation`); the parent integrates the
  useful commits. Child branches normally do not create their own PRs. The
  external review unit stays **1 task = 1 task branch = 1 PR**.

## Handle subagent failure automatically

Inspect the failure, retry with a narrower objective if appropriate, assign
another subagent if useful, or complete the work in the parent when necessary.
Do not abandon the whole task because one attempt failed. Do not re-send the
same failing instruction without changing the approach.

## Independent review

For meaningful changes, ask an agent that did not implement the change to
review the final diff for: unintended behaviour, missing edge cases, wrong
assumptions, inconsistent architecture, insufficient tests, security problems,
and accidental unrelated modifications. The parent stays responsible for
deciding whether review findings require changes.