FROM --platform=linux/amd64 ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# ── System packages ───────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    jq \
    python3 \
    python3-pip \
    unzip \
    wget \
    sudo \
    cifs-utils \
    git \
    zsh \
    p7zip-full \
    # ── Critical dependencies for Onyx & OpenCode (do not remove) ──────────────
    libgl1 \
    libglu1-mesa \
    libx11-6 \
    libfontconfig1 \
    libfreetype6 \
    xvfb \
    alsa-utils \
    libpulse0 \
    # ──────────────────────────────────────────────────────────────────────────
    build-essential \
    cmake \
    libmbedtls-dev \
    uthash-dev \
    bsdmainutils \
    smbclient \
    libicu-dev \
    icu-devtools \
    && rm -rf /var/lib/apt/lists/*

# ── Node.js 22 (NodeSource) ───────────────────────────────────────────────────
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && node --version \
    && npm --version

# ── Prettier (for markdown formatting) ───────────────────────────────────────
RUN npm install -g prettier

# # ── .NET 8 Runtime (needed by LibOrbisPkg/PkgTool) ───────────────────────────
# # We install the slim runtime (not SDK) since we ship a pre-built binary.
# # libssl1.1 is also required by the LibOrbisPkg .NET 8 self-contained binary.
# RUN apt-get update && apt-get install -y --no-install-recommends dotnet-runtime-8.0 \
#     && rm -rf /var/lib/apt/lists/*

# RUN wget -q http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
#     -O /tmp/libssl.deb \
#     && dpkg -i /tmp/libssl.deb \
#     && rm /tmp/libssl.deb

# # ── Onyx CLI (mtolly/onyx — Linux x86_64 AppImage) ───────────────────────────
# # Version 20251011 — the last tested release. Onyx is used for DTA conversion
# # utilities (bin-to-dta, etc.) on files that need it.
# # We run Onyx under `xvfb-run -a` to satisfy its GUI/audio dependency headlessly.
# ARG ONYX_TAG=20251011

# RUN set -ex; \
#     ONYX_URL="https://github.com/mtolly/onyx/releases/download/${ONYX_TAG}/onyx-${ONYX_TAG}-linux-x64.AppImage"; \
#     echo "Downloading Onyx ${ONYX_TAG} from ${ONYX_URL}"; \
#     curl -fsSL "${ONYX_URL}" -o /tmp/onyx.AppImage \
#     && mkdir -p /tmp/onyx-extracted \
#     && 7z x /tmp/onyx.AppImage -o/tmp/onyx-extracted usr/bin/onyx usr/lib \
#     && cp /tmp/onyx-extracted/usr/bin/onyx /usr/local/bin/ \
#     && if [ -d /tmp/onyx-extracted/usr/lib ]; then cp -rn /tmp/onyx-extracted/usr/lib/* /usr/local/lib/; fi \
#     && chmod +x /usr/local/bin/onyx \
#     && ldconfig \
#     && rm -rf /tmp/onyx.AppImage /tmp/onyx-extracted

# # ── LibOrbisPkg PkgTool (maxton/LibOrbisPkg — Linux x64 self-contained) ───────
# # PkgTool is used to extract/decrypt PS4 fPKG files without needing real RSA keys.
# # The standard zero-filled 32-char passcode (00000...0) unlocks user fPKGs.
# # Note: requires libssl1.1 (installed above) and DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1.
# ARG PKGTOOL_VERSION=0.2.231
# RUN wget -q "https://github.com/maxton/LibOrbisPkg/releases/download/v0.2/PkgTool.Core-linux-x64-${PKGTOOL_VERSION}.zip" \
#     -O /tmp/pkgtool.zip \
#     && unzip -q /tmp/pkgtool.zip -d /tmp/pkgtool \
#     && cp /tmp/pkgtool/PkgTool.Core /usr/local/bin/ \
#     && chmod +x /usr/local/bin/PkgTool.Core \
#     && rm -rf /tmp/pkgtool.zip /tmp/pkgtool

# ── OpenCode CLI (anomalyco/opencode — Linux x64) ─────────────────────────────
# OpenCode is used for various Rock Band modding and exploration tasks via CLI.
RUN curl -fsSL -o /tmp/opencode.tar.gz https://github.com/anomalyco/opencode/releases/download/v1.4.0/opencode-linux-x64.tar.gz \
    && tar -xzf /tmp/opencode.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/opencode \
    && rm /tmp/opencode.tar.gz

# ── Smoke tests ───────────────────────────────────────────────────────────────
# RUN onyx 2>&1 | grep "Onyx Music Game Toolkit" || echo "⚠️  Onyx version check failed"
# RUN DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 PkgTool.Core version 2>&1 | grep -i "pkgtool\|0\." || echo "⚠️  PkgTool version check failed"
RUN opencode --version 2>&1 | grep -i "opencode" || echo "⚠️  OpenCode version check failed"

# ── Non-root user (vscode convention) ────────────────────────────────────────
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Fix for Ubuntu 24.04: the default 'ubuntu' user also has UID 1000 — remove it
RUN if getent passwd $USER_UID > /dev/null; then \
    userdel -r ubuntu || true; \
    fi \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
RUN usermod -s /usr/bin/zsh $USERNAME \
    && sudo -u $USERNAME sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

USER $USERNAME
WORKDIR /workspace
