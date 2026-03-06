# Delivery-Orchestrator — Tools

## Available Tools
- `sessions_spawn` — spawn worker sub-agents (codex-builder, kimi-analyst, deepseek-challenger)
- `sessions_list` — check status of active workers
- `memory_search` — retrieve relevant context before routing
- `memory_get` — read specific memory files
- Filesystem access for reading specs, PRDs, and project structure

## Beads CLI (in project directories)
- `bd list --json` — see all tasks and their status
- `bd ready --json` — find next available work
- `bd create` — create new tasks/epics for worker assignment
- `bd prime` — get project context at session start
- `bd sync` — sync state after work completes

## When Spawning Workers
Always include in the task description:
1. The exact project directory path
2. The scale level (L0-L4)
3. Specific scope boundaries (what to touch, what NOT to touch)
4. Acceptance criteria
5. Any relevant context from memory search
