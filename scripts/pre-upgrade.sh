#!/usr/bin/env bash
# Pre-Upgrade Guard — run BEFORE openclaw update
# Backs up all custom multi-agent config that upgrades may overwrite

set -euo pipefail

TIMESTAMP=$(date +%s)
OPENCLAW_DIR="$HOME/.openclaw"
BACKUP_DIR="$OPENCLAW_DIR/upgrade-backups/$TIMESTAMP"

echo "=== OpenClaw Pre-Upgrade Guard ==="
echo "Backup target: $BACKUP_DIR"

mkdir -p "$BACKUP_DIR"

# 1. Backup openclaw.json (most at-risk)
cp "$OPENCLAW_DIR/openclaw.json" "$BACKUP_DIR/openclaw.json"
echo "[OK] openclaw.json backed up"

# 2. Backup systemd service (proxy env vars at risk)
SYSTEMD_FILE="$HOME/.config/systemd/user/openclaw-gateway.service"
if [[ -f "$SYSTEMD_FILE" ]]; then
    cp "$SYSTEMD_FILE" "$BACKUP_DIR/openclaw-gateway.service"
    echo "[OK] systemd service backed up"
else
    echo "[SKIP] systemd service not found"
fi

# 3. Backup agent auth credentials
for agent in jarvis code; do
    AGENT_DIR="$OPENCLAW_DIR/agents/$agent/agent"
    if [[ -d "$AGENT_DIR" ]]; then
        mkdir -p "$BACKUP_DIR/agents/$agent"
        cp "$AGENT_DIR"/*.json "$BACKUP_DIR/agents/$agent/" 2>/dev/null || true
        echo "[OK] $agent agent auth backed up"
    fi
done

# 4. Snapshot current state
echo "" >> "$BACKUP_DIR/state.txt"
echo "=== openclaw status ===" >> "$BACKUP_DIR/state.txt"
openclaw status 2>&1 >> "$BACKUP_DIR/state.txt" || true
echo "" >> "$BACKUP_DIR/state.txt"
echo "=== openclaw doctor ===" >> "$BACKUP_DIR/state.txt"
openclaw doctor 2>&1 >> "$BACKUP_DIR/state.txt" || true
echo "[OK] state snapshot saved"

# 5. Record critical config sections for diff
echo "" > "$BACKUP_DIR/critical-sections.txt"
for key in agents.list tools bindings channels.discord.threadBindings; do
    echo "--- $key ---" >> "$BACKUP_DIR/critical-sections.txt"
    python3 -c "
import json, sys
with open('$OPENCLAW_DIR/openclaw.json') as f:
    d = json.load(f)
keys = '$key'.split('.')
for k in keys:
    d = d.get(k, {})
print(json.dumps(d, indent=2))
" >> "$BACKUP_DIR/critical-sections.txt" 2>/dev/null || echo "(not found)" >> "$BACKUP_DIR/critical-sections.txt"
done
echo "[OK] critical sections extracted"

echo ""
echo "=== Backup complete: $BACKUP_DIR ==="
echo "Files:"
ls -la "$BACKUP_DIR"
echo ""
echo "You can now safely run: openclaw update"
