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

## HALT Check
At session start, after `bd prime`, check for critical blockers:
```bash
bd list --type blocker --priority 0 --status open --json
```
If any HALTs exist, resolve them before proceeding with new work.

## Molecule Workflows
For L3/L4 scale work, use molecules to create structured task hierarchies:
```bash
bd mol pour bmad-feature --args "title=Feature Name"
bd mol pour bmad-bugfix --args "title=Bug Description"
```
Molecules create epics with phased tasks and gates automatically.

## Landing the Plane
NEVER leave tasks in `in_progress` when ending a session:
1. Close all claimed tasks: `bd close <id> --reason "summary"`
2. Sync state: `bd sync`
3. If you cannot finish a task, update its status back to `open` with a note

## Memory
- Write significant decisions to memory/YYYY-MM-DD.md
- Architecture decisions, patterns chosen, tech debt identified
- This persists across sessions and helps future agents
