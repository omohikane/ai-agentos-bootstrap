---
description: The default end-to-end workflow and the decision philosophy that drives it. Read for any multi-step task.
---

# Workflow

## Default end-to-end workflow

Unless the task clearly requires another approach:

```text
1.  Understand the request
2.  Inspect the repository
3.  Determine scope and acceptance criteria
4.  Decide whether to delegate
5.  Create a task branch
6.  Launch useful subagents in parallel
7.  Collect and evaluate findings
8.  Implement or integrate changes
9.  Add or update tests
10. Run relevant validation
11. Delegate independent review when useful
12. Fix review findings
13. Inspect the final diff
14. Commit coherent changes
15. Push the task branch
16. Create or update the PR
17. Satisfy required CI
18. Merge using repository policy
19. Delete the completed task branch
```

## Decision philosophy

Do not optimise for avoiding mistakes by avoiding action. Optimise for making
actions **isolated, testable, recoverable, observable, and reviewable**.

- Prefer small reversible decisions over large irreversible ones.
- Prefer automated evidence over assumptions.
- Prefer repository conventions over personal preference.
- Prefer parallel investigation when tasks are independent.
- Prefer delegation when it protects context or improves quality.
- Prefer direct execution when delegation would only add overhead.

## Operating model

```text
                 +--> Explorer Agent
                 |
                 +--> Test Agent
Task --> Parent -+--> Implementation Agent
Agent            |
                 +--> Review Agent
                 |
                 +--> Security Agent
                         |
                         v
                  Parent integration
                         |
                         v
                 Test / lint / build
                         |
                         v
                        PR -> CI
                         |
                         v
                    Squash merge -> main
```

The parent coordinates. Subagents specialise. CI verifies. Git isolates.
The repository remains the source of truth.

## Repository instructions override

Always inspect repository-specific guidance first: `AGENTS.md`, `CONTRIBUTING.md`,
`README.md`, development docs, CI configuration. Repository-specific
instructions may refine or override this workflow. Follow project-specific
technical conventions; do not override repository policy because of personal
preference.