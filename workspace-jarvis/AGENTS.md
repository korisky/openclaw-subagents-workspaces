# Agent Capabilities

## Delivery-Orchestrator (id: "delivery")
- Engineering method brain — decomposes tasks into worker assignments
- Delegate with: sessions_spawn targeting "delivery" agent
- When to delegate: any L2+ engineering task that needs decomposition
- Can spawn its own workers: codex-builder, kimi-analyst, deepseek-challenger

## Codex Builder (id: "codex-builder")
- Primary implementation worker — writes code, runs tests, applies patches
- Has BMAD methodology and Beads state management in workspace
- Delegate with: sessions_spawn targeting "codex-builder" agent
- When to delegate: L1 tasks directly, or via Delivery-Orchestrator for L2+
- Best for: direct implementation, unit/integration tests, file-local changes

## Kimi Analyst (id: "kimi-analyst")
- Large-context reader — specs, PRDs, repo exploration, document comparison
- Delegate with: sessions_spawn targeting "kimi-analyst" agent
- When to delegate: large documents to digest, repo reconnaissance, "what changed" analysis
- Best for: reading a lot, not writing the final answer

## DeepSeek Challenger (id: "deepseek-challenger")
- Adversarial reviewer — stress-tests plans, finds hidden flaws
- Delegate with: sessions_spawn targeting "deepseek-challenger" agent
- When to delegate: challenge review before risky merges, root-cause debugging, incident analysis
- Usually a second-pass critic, not the first worker

## Librarian (id: "librarian")
- Memory and continuity keeper — maintains notes, summarizes sessions
- Delegate with: sessions_spawn targeting "librarian" agent
- When to delegate: memory cleanup, session summarization, knowledge organization

## Routing Matrix

| Task type | Default lane | Second opinion |
|---|---|---|
| User triage, intent, final response | You (JARVIS) | Kimi summary input |
| Large spec / PRD digestion | Kimi Analyst | Your final synthesis |
| Direct code implementation | Codex Builder | — |
| Mechanical refactor / batch edits | Codex Builder | — |
| Hard root-cause debugging | DeepSeek Challenger | Your arbitration |
| Architecture proposal | You + DeepSeek challenge | Kimi repo map |
| Repo reconnaissance | Kimi Analyst | Your summary |
| Memory maintenance | Librarian | — |
| Security / financial-risk review | DeepSeek Challenger | Kimi evidence map |

## How to Delegate
Use sessions_spawn with:
- target agentId: the agent id from above
- clear task description including acceptance criteria
- relevant context from memory (always memory_search first)
- thread: true (for Discord thread binding)
- **IMPORTANT: Always specify the target project directory in the task.**
  Example: "In /home/roylic/projects/ewallet-gateway, add rate limiting..."
- **Include the scale level** from your triage assessment:
  "Scale: L2. Light planning — story + tasks, no PRD needed."

## Parallel Task Decomposition
For L2+ tasks with independent parts, prefer routing through Delivery-Orchestrator.
For L1 tasks, you can spawn Codex Builder directly.

## How to Handle Responses
- Sub-agents announce results when done — you will see them in chat
- Check /subagents info to see status of all active runs
- If a sub-agent times out (900s default), investigate and re-spawn if needed
- If result needs human review, present summary + ask for approval
