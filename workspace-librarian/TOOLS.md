# Librarian Agent — Tools

## Available Tools
- Full filesystem access (read and write)
- memory_search — search across workspace memories
- memory_get — read specific memory files
- Shell execution for file management

## Workspace Memory Locations

All workspaces live under the `openclaw-subagents-workspaces/` directory
(sibling to this workspace). Each has a `MEMORY.md`:

- JARVIS: `../workspace-jarvis/MEMORY.md`
- Delivery: `../workspace-delivery/MEMORY.md`
- Codex Builder: `../workspace-codex/MEMORY.md`
- Kimi Analyst: `../workspace-kimi/MEMORY.md`
- DeepSeek Challenger: `../workspace-deepseek/MEMORY.md`
- Librarian: `./MEMORY.md` (this workspace)

## Conventions
- Use relative paths from the workspaces root, not absolute paths
- When summarizing sessions, write to the relevant agent's MEMORY.md
- Keep memory files concise — prune stale entries when consolidating
