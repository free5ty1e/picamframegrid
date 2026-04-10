#!/usr/bin/env bash
# =============================================================================
# setup_devcontainer.sh — Runs on container creation
# =============================================================================

set +e

echo "=========================================="
echo "🚀 Dev Container Setup"
echo "=========================================="

# 1. Show environment info
echo ""
echo "📋 Environment:"
echo "   Onyx: $(onyx | head -1)"
echo "   Node: $(node --version)"
echo "   Python: $(python3 --version)"

# 2. Initialize .ai_working folder structure
echo ""
echo "📁 Initializing .ai_working/..."
bash .devcontainer/setup_ai_working.sh

# 3. Mount RB4 DLC share (if available)
echo ""
echo "📦 Mounting RB4 DLC share..."
bash .devcontainer/mount_rb4_dlc.sh

# 4. Fix permissions for opencode data
echo ""
echo "🔧 Fixing permissions..."
mkdir -p /home/vscode/.local/state /home/vscode/.local/share /home/vscode/.local/config 2>/dev/null || true
sudo chown -R vscode:vscode /home/vscode/.local 2>/dev/null || chown -R vscode:vscode /home/vscode/.local 2>/dev/null || true
echo "   ✅ Permissions fixed"

# 5. Initialize PS4 PKG investigation tools
echo ""
echo "🛠️ Setting up PS4 PKG tools..."
cd /workspace
if [ ! -d "ps4_pkg_tool" ]; then
    echo "   - Cloning ps4_pkg_tool..."
    git clone --depth 1 https://github.com/mc-17/ps4_pkg_tool.git ps4_pkg_tool 2>/dev/null || true
fi
if [ ! -d "PkgToolBox" ]; then
    echo "   - Cloning PkgToolBox..."
    git clone --depth 1 https://github.com/seregonwar/PkgToolBox.git 2>/dev/null || true
fi
if [ ! -d "shadPS4Plus" ]; then
    echo "   - Cloning shadPS4Plus..."
    git clone --depth 1 --branch PKG_EXTRACTOR_1_1 https://github.com/AzaharPlus/shadPS4Plus.git 2>/dev/null || true
fi
echo "   ✅ PS4 tools ready"

# 6. Initialize Rock Band 4 Deluxe tools (THE KEY TO SONG EXTRACTION!)
echo ""
echo "🎸 Setting up RB4 extraction tools..."
cd /workspace
if [ ! -d "LibForge" ]; then
    echo "   - Cloning LibForge (RB4 file extraction)..."
    git clone --depth 1 https://github.com/mtolly/LibForge.git LibForge 2>/dev/null || true
fi
if [ ! -d "rb4dx_repo" ]; then
    echo "   - Cloning Rock Band 4 Deluxe source..."
    git clone --depth 1 https://github.com/hmxmilohax/Rock-Band-4-Deluxe.git rb4dx_repo 2>/dev/null || true
fi
echo "   ✅ RB4 tools ready"

echo ""
echo "=========================================="
echo "✅ Dev container ready!"
echo "=========================================="
echo ""
echo "To resume your session:"
echo "   Press Ctrl+Shift+P → 'Tasks: Run Task' → 'Opencode: Resume Last Session'"
echo ""
