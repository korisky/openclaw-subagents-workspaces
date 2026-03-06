# OpenClaw-JARVIS Multi-Agent Test Plan

## Phase 1: Core Loop Validation

### Test 1.1 — JARVIS Basic Response
**Command**: Send on Discord: `Hello JARVIS`
**Expected**: JARVIS responds as coordinator. Should NOT delegate (simple question).
**Pass if**: Response received, tone matches SOUL.md personality.

### Test 1.2 — JARVIS Triage (L1 — Simple Task)
**Command**: `Create a hello world Python script in /tmp/test-jarvis`
**Expected**:
1. JARVIS recognizes as code task (Delegation Trigger)
2. JARVIS spawns Code Agent via `sessions_spawn`
3. Discord thread created for the sub-agent
4. Code Agent creates the script
5. Code Agent announces back with structured summary
6. JARVIS relays result to you in main channel
**Pass if**: File exists at `/tmp/test-jarvis/hello.py` and JARVIS relays the result.

### Test 1.3 — Agent Isolation
**Command**: `openclaw agents list --bindings` (CLI)
**Expected**: Two agents listed — `jarvis` (default, bound to discord) and `code` (no binding).
**Pass if**: Output shows both agents with correct roles.

### Test 1.4 — Sub-Agent Status Check
**Command**: Send on Discord: `what's happening?`
**Expected**: JARVIS summarizes active/recent sub-agents. If none active, says so.
**Pass if**: Response acknowledges the sub-agent system.

### Test 1.5 — Code Agent Timeout/Announce-Back
**Command**: Send a slightly complex task, e.g., `In /tmp/test-jarvis, create a Python CLI calculator that supports add, subtract, multiply, divide`
**Expected**: Code Agent works autonomously, announces structured summary (what was done, files changed, follow-up).
**Pass if**: JARVIS relays completion, files exist, announcement is structured per SOUL.md spec.

---

## Phase 2: Bug #5813 Test (Day 2)

### Test 2.1 — sessions_spawn with agentToAgent disabled (current)
**Precondition**: `tools.agentToAgent.enabled: false` (current config)
**Command**: Send a code task on Discord.
**Expected**: Sub-agent spawns and executes normally.
**Pass if**: Code Agent runs and announces back.

### Test 2.2 — Enable agentToAgent
**Action**: Edit `~/.openclaw/openclaw.json`, change `"tools.agentToAgent.enabled"` to `true`. Restart gateway.
**Command**: Send a code task on Discord.
**Expected**: Sub-agent spawns and executes normally.
**Fail indicator**: Sub-agent appears but 0 tokens consumed (Bug #5813).
**If fails**: Revert `agentToAgent.enabled` to `false`. Document version affected.

---

## Phase 3: Parallel Spawning

### Test 3.1 — Multiple Parallel Sub-Agents
**Command**: `Create two files in /tmp/test-jarvis: a Python fibonacci calculator AND a bash script that lists system info. Do them in parallel.`
**Expected**: JARVIS spawns 2 Code Agent sub-agents simultaneously.
**Pass if**: Both tasks complete, JARVIS synthesizes results.

### Test 3.2 — maxConcurrent Limit
**Command**: Send 6+ independent code tasks rapidly.
**Expected**: At most 5 sub-agents run concurrently (per `subagents.maxConcurrent: 5`).
**Pass if**: Tasks queue and complete without crashes.

---

## Phase 4: Escalation & Decision Flow

### Test 4.1 — Ambiguous Task
**Command**: `Set up the database for my project` (no project path specified)
**Expected**: JARVIS asks which project/repo before delegating.
**Pass if**: JARVIS asks for clarification, does NOT blindly spawn.

### Test 4.2 — Decision Fork (Gate)
**Command**: `In /tmp/test-jarvis, create a web server — use whatever framework you think is best but check with me first`
**Expected**: Code Agent creates a decision gate and announces options. JARVIS relays using Escalation Format.
**Pass if**: You see the decision prompt with options.

---

## Phase 5: Memory (after several interactions)

### Test 5.1 — Memory Search
**Command**: `Do you remember what we worked on?`
**Expected**: JARVIS runs `memory_search` and returns context from past interactions.
**Pass if**: Response references previous tasks (BM25 keyword match at minimum).

### Test 5.2 — Memory Files Created
**Check**: `ls ~/.openclaw/openclaw-subagents-workspaces/workspace-jarvis/memory/`
**Expected**: Daily log files (YYYY-MM-DD.md) created after interactions.

---

## Phase 6: Beads Integration (after bd is installed)

### Test 6.1 — Beads CLI Available
**Command**: Ask JARVIS: `In ~/projects/<project>, run bd --version and bd prime`
**Expected**: Code Agent reports Beads version and project state.
**Pass if**: bd commands execute successfully.

### Test 6.2 — Beads Task Workflow
**Command**: `In ~/projects/<project>, create a Beads task for 'Add rate limiting' and show me the task list`
**Expected**: Code Agent runs `bd create`, then `bd list`, announces results.
**Pass if**: Task appears in Beads list.

### Test 6.3 — Gate Flow
**Command**: Ask for something requiring a decision in a Beads-enabled project.
**Expected**: Code Agent creates a Beads gate + includes gate ID in announcement. JARVIS relays.
**Pass if**: Gate ID visible in JARVIS relay.

---

## Diagnostics Cheat Sheet

```bash
# Gateway status
systemctl --user status openclaw-gateway.service

# Live logs
openclaw logs --follow

# Full status
openclaw status --deep

# Config validation
openclaw doctor

# Agent listing
openclaw agents list --bindings

# Recent logs
journalctl --user -u openclaw-gateway.service --since "5 min ago" --no-pager

# Check sessions
openclaw status  # Sessions table at bottom
```

## Known Limitations

- Memory search is BM25-only (no embedding provider) — keyword match works, semantic doesn't
- Beads CLI (bd) not installed — Code Agent will proceed without it
- Heartbeat runs every 30m for JARVIS (can't disable at agent level in this OpenClaw version)
