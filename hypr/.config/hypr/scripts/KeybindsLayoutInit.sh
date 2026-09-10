#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Initialize J/K keybinds so they always cycle windows globally (no layout-specific behavior)
# This avoids double-actions when layouts change.

set -euo pipefail
# Hyprland parser compatibility (legacy .conf vs lua) - see hypr-compat.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hypr-compat.sh"


# Always reset and bind SUPER+J/K the same way on startup
hypr_unbind "SUPER,J" "SUPER + J" || true
hypr_unbind "SUPER,K" "SUPER + K" || true

# Cycle windows globally: J = next, K = previous
hypr_bind "SUPER,J,cyclenext" 'hl.bind("SUPER + J", hl.dsp.window.cycle_next())'
hypr_bind "SUPER,K,cyclenext,prev" 'hl.bind("SUPER + K", hl.dsp.window.cycle_next({ next = false }))'
