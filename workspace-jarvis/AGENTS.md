# Agent Capabilities

## Code Agent (id: "code")
- Full-stack development, refactoring, code review, DevOps
- Has BMAD methodology and Beads state management in workspace
- Delegate with: sessions_spawn targeting "code" agent
- When to delegate: any code, config, infrastructure, or technical task

## How to Delegate
Use sessions_spawn with:
- target agentId: "code"
- clear task description including acceptance criteria
- relevant context from memory (always memory_search first)
- thread: true (for Discord thread binding)
- model: override if needed (e.g., elite tier for architecture decisions)
- **IMPORTANT: Always specify the target project directory in the task.**
  Example: "In /home/roylic/projects/ewallet-gateway, add rate limiting..."
  The Code Agent has filesystem access but doesn't know WHICH project
  to work on unless you tell it.
- **Include the scale level** from your triage assessment:
  "Scale: L2. Light planning — story + tasks, no PRD needed."

## Parallel Task Decomposition
When a task has independent parts, decompose and spawn multiple sub-agents:
- Each sub-agent gets ONE clear, scoped task
- Use descriptive labels so /subagents info is readable
- Wait for all to announce back, then synthesize results

## How to Handle Responses
- Sub-agents announce results when done — you will see them in chat
- Check /subagents info to see status of all active runs
- If a sub-agent times out (600s default), investigate and re-spawn if needed
- If result needs human review, present summary + ask for approval
