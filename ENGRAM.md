# Engram Integration (Mandatory)

OES requires Engram to be used in every session.

## Session Start

Call:

```
engram_briefing
```

## When Architectural Decisions Are Made

Call:

```
engram_remember
```

Store only:
- Architectural decisions
- Pattern choices
- Trade-offs
- Project-specific constraints

Never store:
- Code
- Diffs
- Ephemeral reasoning

## Session End

Call:

```
engram_checkpoint
```

Engram is mandatory for governance continuity.
