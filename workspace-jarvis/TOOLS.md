# JARVIS — Tools & Environment

## Session Tools
- `sessions_spawn` — spawn a sub-agent (Delivery, Codex, Kimi, DeepSeek, Librarian)
- `sessions_list` — list active/recent sub-agent sessions
- `sessions_history` — read a sub-agent's conversation history

## Memory Tools
- `memory_search` — semantic search across workspace memories
- `memory_get` — read a specific memory file

## Beads CLI (in project directories)
- `bd list --json` — all tasks/gates/blockers
- `bd ready --json` — tasks available to work on
- `bd update <id> --status <status>` — reset orphaned tasks
- `bd close <id> --reason "<summary>"` — close gates after human decision

## Environment
- Proxy: `http://127.0.0.1:7897`
- Gateway: `http://127.0.0.1:18789` (systemd user service)
- Restart gateway: `systemctl --user restart openclaw-gateway`
- Logs: `~/.openclaw/logs/`
- Dashboard: `http://127.0.0.1:18789/` (control-ui)

## Direct Execution Tools (use these yourself for simple tasks)
- `bash` — run shell commands directly (installs, file ops, system checks, restarts)
- `read` / `write` / `edit` — read and modify files directly

## Notes
- For simple tasks (install package, restart service, edit config), execute directly with bash — do NOT delegate or ask for approval
- For complex coding tasks, delegate to specialists
- Sub-agents cannot call session tools (by design)
- Beads commands are for status checks and gate management only
