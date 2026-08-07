# opencode-guide — draft of AGENTS.md + skills

A split of the long "Autonomous Coding Agent Instructions" into a short root
`AGENTS.md` plus role-based skills that opencode can load. **This is a draft.
Work in progress.**

## What is here

```
opencode-guide/
├── AGENTS.md              # concise core principles + pointer to skills
└── skills/                # copy to .opencode/skills/ or ~/.config/opencode/skills/
    ├── task-execution.md  # understand / decompose / scope / preserve / DoD
    ├── subagents.md       # delegation / parents / parallelism / review
    ├── git-workflow.md    # task branch model / commits / PR / merge
    ├── validation.md      # run checks / never fabricate / test integrity
    ├── security.md        # boundaries / secrets / production
    └── workflow.md        # default workflow / philosophy / repo override
```

## Where each original section went

| Original section | Where it lives now |
|---|---|
| 1 Operate Autonomously | `AGENTS.md` core principles |
| 2 Understand Before Editing | `skills/task-execution.md` §1 |
| 3 Decompose Complex Tasks | `skills/task-execution.md` §2 |
| 4 Use Subagents / 5 Parent / 6 Sub / 7 Parallelise | `skills/subagents.md` |
| 8 Protect Context / 9 Specialist roles | `skills/subagents.md` |
| 10 Independent Review | `skills/subagents.md` (review) |
| 11-15 Git task model / workflow / commit | 3 `skills/git-workflow.md` |
| 16 Keep Changes Scoped | `skills/task-execution.md` §3 |
| 17-19 Validation / fabricate / tests | `skills/validation.md` |
| 20 Final Diff Review | `skills/validation.md` |
| 21-22 PR / merge / 23 hooks / 24 preserve / 25 force-push / 26 worktrees | `skills/git-workflow.md` |
| 27-30 Subagent git strategy / conflicts | `skills/subagents.md` + `git-workflow.md` |
| 31-32 Security / production | `skills/security.md` |
| 33 Repo instructions override | `skills/workflow.md` |
| 34 Definition of Done | `skills/task-execution.md` §5 |
| 35 Default workflow | `skills/workflow.md` |
| 36 Decision philosophy | `skills/workflow.md` |
| Core operating principle | `AGENTS.md` + `skills/workflow.md` |

## How to activate

On a provisioned AI agent VM this is done for you: the `ai` Ansible role
(`ansible/roles/ai/tasks/agent-guide.yml`) copies these files into the agent
user's global opencode config (`~/.config/opencode/AGENTS.md` and
`~/.config/opencode/skills/`).

For other repositories:

```text
cp opencode-guide/AGENTS.md AGENTS.md
mkdir -p .opencode/skills
cp opencode-guide/skills/*.md .opencode/skills/
```

Globally (optional):

```text
mkdir -p ~/.config/opencode/skills
cp -r opencode-guide/skills/*.md ~/.config/opencode/skills/
```

(The skill files already carry the rationale `description` frontmatter so they
get picked up when relevant.)

## Notes / trade-offs

- The root keeps only 7 core principles; details live in skills. Keeps every
  prompt light and loads detail on demand.
- `security` is separate so credentials/production topics are a hard stop.
- Two areas conflict with the operator-level AGENTS.md in this repo: autonomy
  vs. explicit confirmation, and git push policies. Decide per context when
  adopting; this draft leaves the operator rules intact here.