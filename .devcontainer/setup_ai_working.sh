#!/usr/bin/env bash
# =============================================================================
# setup_ai_working.sh — Initialize .ai_working folder for session persistence
# =============================================================================

set +e

AI_WORKING="/workspace/.ai_working"
OPENCODE_DATA="$AI_WORKING/opencode_data"

# Create directories if they don't exist
mkdir -p "$OPENCODE_DATA"
mkdir -p "$OPENCODE_DATA/state"
mkdir -p "$OPENCODE_DATA/share"
mkdir -p "$OPENCODE_DATA/config"

echo "✅ Initialized .ai_working/ folder structure"

# If opencode data doesn't exist yet, this is a fresh setup
if [ ! -f "$OPENCODE_DATA/opencode.db" ]; then
    echo "   Note: No existing opencode data found"
    echo "   Run 'opencode' to start a new session, or import from backup"
fi
