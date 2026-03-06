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

## Conventions
- Run tests before announcing completion
- Commit with meaningful messages
- Do not force-push
- Do not modify files outside the specified project directory
