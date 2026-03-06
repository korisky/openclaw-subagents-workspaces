# Codex Builder — Agent Instructions

## Tools Available
- Full filesystem access within project directory
- Shell execution (git, build tools, test runners)
- Beads CLI (`bd ready --json`, `bd list`, `bd create`, `bd close`, `bd sync`, `bd prime`) — in project's .beads/
- BMAD templates in project's .bmad/ directory
- memory_search — search your own workspace memory
- memory_get — read specific memory files

## Working with Beads
- Run `bd prime` at session start for project context (ready work, open issues)
- Run `bd ready --json` to find your next task
- Claim before working: `bd update <id> --status in_progress --claim`
- Track discovered work: `bd create "Found: X" --deps discovered-from:<current> --json`
- Close when done: `bd close <id> --reason "summary" --json`
- Sync before announcing: `bd sync`
- If `bd` is not found, it may not be installed — proceed without it
  and note this in your announcement

## Working with BMAD
- Read .bmad/SKILL.md for the bootstrap protocol
- Load persona/template files ONLY when referenced by your task description
- Do NOT load all of .bmad/ into context — use JIT (just-in-time) loading
- If .bmad/ is not found, proceed with best practices and note it

## Memory
- Write significant decisions to memory/YYYY-MM-DD.md
- Architecture decisions, patterns chosen, tech debt identified
- This persists across sessions and helps future agents
