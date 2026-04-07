# Skill: pr-reviewer (Senior Software Engineer — PR Review)

Activate when:
- `/review-pr` command is used
- User asks to review a pull request
- User asks to check a branch before merge

Constraint: review ONE PR at a time. If multiple are requested, process the first and notify.

---

## Process (mandatory order)

### Step 1 — Identify PR
```bash
gh pr view <number_or_branch> --json number,title,headRefName,baseRefName,additions,deletions,changedFiles,commits
```
Display: title, branch origin → destination, changed files count, commits count.

### Step 2 — Verify compilation
Detect build system (pom.xml → mvnw, build.gradle → gradlew), then:
```bash
./mvnw compile -q 2>&1 | tail -20
# or
./gradlew classes 2>&1 | tail -20
```
If compilation fails → immediate REJECTED verdict. Stop here.

### Step 3 — Read commits
```bash
gh pr view <number> --json commits --jq '.commits[] | "\(.messageHeadline)"'
```
Evaluate commit message quality.

### Step 4 — Read full diff
```bash
gh pr diff <number>
```
Apply full checklist below.

---

## Checklist

Correctness:
- No potential NullPointerExceptions unhandled
- Edge cases handled (null, empty list, DB error)
- Transactions correct and not excessive

Bad practices:
- No business logic in controllers
- No entities returned directly in responses (DTOs only)
- Constructor injection (no field-level @Autowired/@Inject)
- No hardcoded secrets
- No dead commented code without justification
- No TODOs without an associated ticket

Patterns and architecture:
- Layer boundaries respected (controller/resource → service → repository)
- Single responsibility per class and method
- No duplicated logic already present in the project
- Error handling consistent with existing project style

Readability:
- Descriptive names (classes, methods, variables)
- Methods single-purpose, preferably <20 lines
- No cryptic abbreviations
- Structure coherent with the rest of the codebase

Scope and files:
- All modified files belong to the PR's stated functionality
- No style-only changes mixed with functional changes
- No debug, temporary, or test files committed (test.md, debug.txt, etc.)

Commits:
- Descriptive messages following Conventional Commits (feat/fix/refactor/docs/chore)
- No vague messages ("fix", "wip", "changes", "update")
- Each commit has a clear, single purpose

---

## Output format

```
## PR Review: #<N> — <title>
**Branch**: <origin> → <destination>
**Files changed**: N | **Commits**: N

### Compilation
✅ OK / ❌ Error: [detail]

### Commits
✅ Descriptive / ⚠️ Issues:
- [IMPROVEMENT] "<message>" — reason

### Code Issues
- [BLOCKING] `path/File:line` — concise description
- [IMPROVEMENT] `path/File:line` — description
- [SUGGESTION] `path/File:line` — description

### Out-of-scope files
- [BLOCKING] `file` — does not belong to this PR's functionality

### Summary
[3–5 lines: overall state, what's good, what blocks merge]

**Verdict**: APPROVED | APPROVED WITH OBSERVATIONS | REJECTED
```

---

## Verdict rules
- **REJECTED**: requires ≥1 BLOCKING issue. PR cannot be merged.
- **APPROVED WITH OBSERVATIONS**: only IMPROVEMENT and SUGGESTION issues. Can merge with attention.
- **APPROVED**: no issues or only minor suggestions.
- Compilation failure = automatic REJECTED. Do not continue analysis.

---

## Engram

After completing the review, call `engram_remember` if:
- A recurring pattern of bad practices is found (store for future sessions)
- A project-specific convention is discovered or confirmed
- A architectural decision is validated through the review

Never store the full diff or issue list — only durable insights.
