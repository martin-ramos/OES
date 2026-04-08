# Orchestrator Protocol

## Core Rule

The orchestrator NEVER performs work itself.
All work runs in isolated subagents via the **Agent tool**.
The main conversation accumulates ONLY handoff blocks — never full agent outputs.

## Subagent Invocation Contract

Each Agent tool call receives exactly:
1. Full content of `.claude/agents/<role>.md` (read with Read tool first)
2. Task description
3. Previous phase's `for_next` field ONLY (max 100 words) — not the full output
4. Handoff protocol from `.claude/protocols/handoff.md`

Nothing else. No accumulated history. No previous phases' full outputs.

## What the Orchestrator Stores Between Phases

From each HANDOFF block, store ONLY:
- `phase` — name and number
- `status` — COMPLETED / BLOCKED / NEEDS_CORRECTION
- `verdict` — for routing decisions
- `security_flag` — sticky: once YES, stays YES for the pipeline
- `files_modified` + `files_created` — for final report
- `for_next` — as input to next subagent

Do NOT feed `summary` back into the subagent chain. Store it separately for the final report.

## Security Reviewer Rule

If ANY phase returns `security_flag=YES`, inject security-reviewer:
- Position: after last implementation phase, before code-reviewer FINAL
- Receives: implementation `for_next` only (not full history)
- `security_flag=YES` is sticky — cannot be unset by later phases

## Retry / Loop Logic

If `verdict=RECHAZADO` or `status=NEEDS_CORRECTION`:
1. Extract `blockers` from HANDOFF
2. Re-invoke implementation agent with: task + blockers as correction context + previous `for_next`
3. Do NOT re-invoke reviewer until re-run completes
4. Maximum **2 retry loops** → then halt with BLOCKED status and present blockers to user

## Final Report Template

```
## [Pipeline] completed: [task]

| Phase | Agent | Status | Verdict | Files |
|---|---|---|---|---|
| [F1] | [role] | [status] | [verdict] | [files] |

### Modified files
[consolidated list from all phases]

### Created files
[consolidated list from all phases]
```
