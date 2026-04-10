#!/usr/bin/env bash
# =============================================================================
# launch_opencode.sh — Launch opencode with the most recent session
# =============================================================================

# Find the most recent session
SESSION_ID=$(opencode session list 2>/dev/null | tail -n +3 | head -n 1 | awk '{print $1}' || true)

if [ -z "$SESSION_ID" ]; then
    echo "No sessions found. Starting fresh..."
    exec opencode /workspace
else
    echo "Resuming session: $SESSION_ID"
    # Use -c (continue) to resume interactive session
    exec opencode /workspace -c -s "$SESSION_ID"
fi
