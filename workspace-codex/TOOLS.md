# Codex Builder — Tools

## Environment
- Shell: zsh
- OS: EndeavourOS / Linux
- Node.js available
- Git available

## Commands
- `bd prime` — project context at session start
- `bd ready --json` — find next task
- `bd list --json` — all tasks
- `bd create "<title>" [--type task|gate|epic]` — create work items
- `bd close <id> --reason "<summary>"` — close completed work
- `bd sync` — sync beads state
- `bd update <id> --status <status>` — update task status

## Additional Commands
- `bd list --type blocker --priority 0 --status open --json` — check for HALTs before starting work
- `bd mol pour <molecule-name> --args "title=..."` — create structured task hierarchy (L3/L4)
- `bd update <id> --claim` — claim a task (combine with `--status in_progress`)

## Conventions
- Run tests before announcing completion
- Commit with meaningful messages
- Do not force-push
- Do not modify files outside the specified project directory
