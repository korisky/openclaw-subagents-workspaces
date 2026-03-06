#!/usr/bin/env bash
# Post-Upgrade Guard — run AFTER openclaw update
# Verifies multi-agent config survived and repairs if needed

set -euo pipefail

OPENCLAW_DIR="$HOME/.openclaw"
CONFIG="$OPENCLAW_DIR/openclaw.json"
SYSTEMD_FILE="$HOME/.config/systemd/user/openclaw-gateway.service"
ERRORS=0

echo "=== OpenClaw Post-Upgrade Guard ==="
echo ""

# 1. Check agents.list exists with jarvis + code
echo "--- Checking agents.list ---"
AGENT_COUNT=$(python3 -c "
import json
with open('$CONFIG') as f:
    d = json.load(f)
agents = d.get('agents', {}).get('list', [])
ids = [a.get('id') for a in agents]
print(len(agents))
if 'jarvis' in ids: print('jarvis:OK')
else: print('jarvis:MISSING')
if 'code' in ids: print('code:OK')
else: print('code:MISSING')
" 2>/dev/null || echo "0")

if echo "$AGENT_COUNT" | grep -q "MISSING"; then
    echo "[FAIL] agents.list is missing or incomplete!"
    echo "  Restore from backup: ls $OPENCLAW_DIR/upgrade-backups/"
    ERRORS=$((ERRORS + 1))
else
    echo "[OK] agents.list has jarvis + code"
fi

# 2. Check bindings
echo ""
echo "--- Checking bindings ---"
BINDING_OK=$(python3 -c "
import json
with open('$CONFIG') as f:
    d = json.load(f)
bindings = d.get('bindings', [])
for b in bindings:
    if b.get('agentId') == 'jarvis':
        print('OK')
        break
else:
    print('MISSING')
" 2>/dev/null || echo "MISSING")

if [[ "$BINDING_OK" == "MISSING" ]]; then
    echo "[FAIL] Discord binding to jarvis is missing!"
    ERRORS=$((ERRORS + 1))
else
    echo "[OK] Discord bound to jarvis"
fi

# 3. Check tools.sessions.visibility
echo ""
echo "--- Checking tools config ---"
TOOLS_OK=$(python3 -c "
import json
with open('$CONFIG') as f:
    d = json.load(f)
vis = d.get('tools', {}).get('sessions', {}).get('visibility', '')
a2a = d.get('tools', {}).get('agentToAgent', None)
if vis: print(f'visibility:{vis}')
else: print('visibility:MISSING')
if a2a is not None: print('agentToAgent:OK')
else: print('agentToAgent:MISSING')
" 2>/dev/null || echo "MISSING")

if echo "$TOOLS_OK" | grep -q "MISSING"; then
    echo "[FAIL] tools section is missing or incomplete!"
    ERRORS=$((ERRORS + 1))
else
    echo "[OK] tools config intact"
fi

# 4. Check threadBindings
echo ""
echo "--- Checking threadBindings ---"
TB_OK=$(python3 -c "
import json
with open('$CONFIG') as f:
    d = json.load(f)
tb = d.get('channels', {}).get('discord', {}).get('threadBindings', None)
if tb and tb.get('enabled'): print('OK')
else: print('MISSING')
" 2>/dev/null || echo "MISSING")

if [[ "$TB_OK" == "MISSING" ]]; then
    echo "[FAIL] threadBindings missing from Discord config!"
    ERRORS=$((ERRORS + 1))
else
    echo "[OK] threadBindings configured"
fi

# 5. Check workspace paths point to git repo
echo ""
echo "--- Checking workspace paths ---"
python3 -c "
import json
with open('$CONFIG') as f:
    d = json.load(f)
for agent in d.get('agents', {}).get('list', []):
    ws = agent.get('workspace', '')
    aid = agent.get('id', '?')
    if 'openclaw-subagents-workspaces' in ws:
        print(f'[OK] {aid} workspace: {ws}')
    else:
        print(f'[WARN] {aid} workspace changed: {ws}')
" 2>/dev/null

# 6. Check systemd proxy vars
echo ""
echo "--- Checking systemd proxy ---"
if [[ -f "$SYSTEMD_FILE" ]]; then
    PROXY_COUNT=$(grep -c "PROXY" "$SYSTEMD_FILE" || true)
    if [[ "$PROXY_COUNT" -ge 3 ]]; then
        echo "[OK] systemd service has proxy env vars ($PROXY_COUNT lines)"
    else
        echo "[FAIL] systemd service missing proxy env vars!"
        echo "  Add these to [Service] section of $SYSTEMD_FILE:"
        echo "  Environment=HTTP_PROXY=http://127.0.0.1:7897"
        echo "  Environment=HTTPS_PROXY=http://127.0.0.1:7897"
        echo "  Environment=ALL_PROXY=http://127.0.0.1:7897"
        echo "  Environment=NO_PROXY=localhost,127.0.0.1,::1"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "[WARN] systemd service file not found"
fi

# 7. Run openclaw doctor
echo ""
echo "--- Running openclaw doctor ---"
DOCTOR_OUT=$(openclaw doctor 2>&1 || true)
if echo "$DOCTOR_OUT" | grep -qi "invalid config"; then
    echo "[FAIL] Config has validation errors!"
    echo "$DOCTOR_OUT" | grep -i "invalid\|error\|unrecognized"
    ERRORS=$((ERRORS + 1))
else
    echo "[OK] Config validates"
fi

# Summary
echo ""
echo "================================"
if [[ $ERRORS -eq 0 ]]; then
    echo "ALL CHECKS PASSED — multi-agent config survived upgrade"
else
    echo "$ERRORS CHECK(S) FAILED — restore from backup!"
    echo ""
    echo "Latest backup:"
    ls -td "$OPENCLAW_DIR/upgrade-backups/"* 2>/dev/null | head -1
    echo ""
    echo "To restore:"
    echo "  cp <backup>/openclaw.json $CONFIG"
    echo "  systemctl --user daemon-reload"
    echo "  systemctl --user restart openclaw-gateway"
fi
