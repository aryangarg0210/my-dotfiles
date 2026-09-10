#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
#  ML4W overlay — personal customizations on top of a stock ML4W install.
#
#  ML4W owns ~/.config/hypr, ~/.config/waybar, ~/.zshrc and friends via
#  symlinks into ~/.mydotfiles/com.ml4w.dotfiles.stable/. Re-running the
#  ML4W installer can reset anything not in its profile's restore[] list,
#  so this script re-applies our changes. Idempotent: safe to re-run.
#
#  Run after any ML4W install or update:  bash ml4w-overlay.sh
#
#  ML4W 2.15.1 restore[] — files whose user edits ARE preserved:
#      .config/ml4w/settings            .config/hypr/conf/keybinding.lua
#      .config/hypr/input.lua           .config/hypr/conf/environment.lua
#      .config/hypr/gesture.lua         .config/hypr/conf/layout.lua
#      .config/hypr/monitors.lua        .config/hypr/conf/windowrule.lua
#      .config/hypr/hyprland-gui.lua    .config/hypr/conf/animation.lua
#      .config/hypr/conf/monitor.lua    .config/hypr/conf/decoration.lua
#      .config/hypr/hyprsunset.conf     .config/hypr/conf/window.lua
#      .config/hypr/hypridle.conf       .config/hypr/workspaces.lua
#      .config/gtk-3.0  .config/gtk-4.0  .gtkrc-2.0
#
#  Anything NOT on that list (conf/autostart.lua, conf/environments/*)
#  gets overwritten on update — never put customizations there.
# ══════════════════════════════════════════════════════════════════════
set -euo pipefail

ok()   { printf '   ok: %s\n' "$*"; }
note() { printf '\n== %s\n' "$*"; }
warn() { printf '   !! %s\n' "$*"; }

# ── 1. terminal: ghostty, not kitty ──────────────────────────────────
note "terminal"
TERM_FILE="$HOME/.config/ml4w/settings/terminal.sh"
if [[ -f "$TERM_FILE" ]]; then
    if [[ "$(cat "$TERM_FILE")" == "ghostty" ]]; then
        ok "already ghostty"
    else
        echo "ghostty" > "$TERM_FILE"
        ok "set to ghostty (was: kitty)"
    fi
    command -v ghostty >/dev/null || warn "ghostty is not installed"
else
    warn "$TERM_FILE not found — is ML4W installed?"
fi

# ── 2. dual-GPU environment ──────────────────────────────────────────
# ASUS TUF A15: AMD Renoir iGPU + NVIDIA RTX 3050 Mobile, dGPU held off
# via `supergfxctl -m Integrated`. Keep decode/render on the iGPU so the
# dGPU never wakes. Goes in conf/environment.lua because that IS in
# restore[]; conf/environments/default.lua is not.
#
# AQ_DRM_DEVICES is deliberately omitted — with the dGPU off there is one
# device and Hyprland autodetects it. Under hyprlang an inline `#` comment
# on that line was swallowed into the value and poisoned the device path,
# causing a crash loop (June 2026).
note "dual-GPU environment"
ENV_FILE="$HOME/.config/hypr/conf/environment.lua"
if [[ -f "$ENV_FILE" ]]; then
    if grep -q 'LIBVA_DRIVER_NAME.*radeonsi' "$ENV_FILE"; then
        ok "GPU env vars already present"
    else
        cat >> "$ENV_FILE" <<'ENV'

-- Dual-GPU: keep decode/render on the AMD iGPU so the dGPU stays asleep.
-- See docs/migration/ml4w-overlay.sh for why these live here.
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("GSK_RENDERER", "ngl")
ENV
        ok "appended LIBVA_DRIVER_NAME=radeonsi, GSK_RENDERER=ngl"
    fi
else
    warn "$ENV_FILE not found"
fi

# ── 3. shell: personal fragments via ML4W's official hook ────────────
# ML4W sources ~/.zshrc_custom as the last statement of its own .zshrc
# and never overwrites it. The fragments themselves are stowed from this
# repo to ~/.config/zsh (ML4W uses ~/.config/zshrc — different path).
note "shell"
if [[ -f "$HOME/.zshrc_custom" ]] && grep -q 'config/zsh/init-last' "$HOME/.zshrc_custom"; then
    ok "~/.zshrc_custom already wired"
else
    cat > "$HOME/.zshrc_custom" <<'ZC'
# Managed by my-dotfiles/docs/migration/ml4w-overlay.sh
# ML4W sources this last and never overwrites it.
[ -f "$HOME/.config/zsh/shortcuts.zsh" ] && source "$HOME/.config/zsh/shortcuts.zsh"
# must stay last — zoxide requires nothing mutate precmd after it
[ -f "$HOME/.config/zsh/init-last.zsh" ] && source "$HOME/.config/zsh/init-last.zsh"
ZC
    ok "wrote ~/.zshrc_custom"
fi
[[ -L "$HOME/.config/zsh" ]] || warn "~/.config/zsh is not stowed — run: stow -t ~ zsh"

# ── 4. verify ────────────────────────────────────────────────────────
note "verify"
if command -v Hyprland >/dev/null; then
    if Hyprland --verify-config 2>&1 | grep -q "config ok"; then
        ok "hyprland config parses"
    else
        warn "hyprland config has errors — run: Hyprland --verify-config"
    fi
fi

printf '\nOverlay applied. Log out and back in for env changes to take effect.\n'
