#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
#  Phase 4 — package purge + GPU mode switch.
#
#  Scope was narrowed by the user's decisions on 2026-09-10: dev tooling,
#  heavy work apps, browsers, AI editors and the spotify stack all STAY.
#  What goes is cruft with no reverse dependencies, drivers for hardware
#  this machine does not have, and two apps with no data behind them.
#
#  Shows every transaction before running it. Nothing is removed without
#  pacman's own confirmation prompt.
#
#  Run:  sudo bash phase4-purge.sh
# ══════════════════════════════════════════════════════════════════════
set -uo pipefail

note() { printf '\n══ %s\n' "$*"; }
ok()   { printf '   ok: %s\n' "$*"; }
warn() { printf '   !! %s\n' "$*"; }

[[ $EUID -eq 0 ]] || { echo "run with sudo"; exit 1; }

BEFORE_EXPLICIT=$(pacman -Qqe | wc -l)
BEFORE_TOTAL=$(pacman -Q | wc -l)
note "before: $BEFORE_EXPLICIT explicit / $BEFORE_TOTAL total"

# Remove a group only if every package is installed and nothing needs it.
# Skipping missing packages keeps the script re-runnable.
remove_group() {
    local label="$1"; shift
    local present=()
    for p in "$@"; do
        pacman -Qq "$p" &>/dev/null && present+=("$p")
    done
    note "$label"
    if (( ${#present[@]} == 0 )); then
        ok "nothing to remove (already gone)"
        return 0
    fi
    printf '   removing: %s\n' "${present[*]}"
    if ! pacman -Rns "${present[@]}"; then
        warn "group '$label' failed — continuing with the next group"
        return 1
    fi
}

# ── 1. debug packages (yay build artifacts; asusctl-debug is also stale
#       at 6.3.8 against asusctl 6.4.0) ───────────────────────────────
remove_group "debug packages" \
    asusctl-debug 64gram-desktop-bin-debug clipse-debug k6-debug \
    kind-bin-debug litehtml0.9-debug overskride-debug \
    spicetify-cli-debug wallust-debug yay-debug

# ── 2. drivers for hardware that does not exist here ─────────────────
#       AMD Renoir iGPU + NVIDIA RTX 3050. No Intel GPU at all, and
#       nouveau is unused because the card runs nvidia-open-dkms.
remove_group "wrong-hardware drivers" \
    intel-media-driver libva-intel-driver vulkan-intel \
    xf86-video-nouveau vulkan-nouveau

# ── 3. Xorg leftovers on a Wayland session ───────────────────────────
#       xorg-server is deliberately NOT here: sddm requires it and
#       pacman refuses the removal. XWayland is the separate
#       xorg-xwayland package and is untouched.
remove_group "xorg leftovers" \
    xorg-xinit xf86-video-amdgpu xf86-video-ati

# ── 4. apps with no data behind them ─────────────────────────────────
#       ollama: ~/.ollama absent, so no models were ever pulled.
#       virtualbox: ~/VirtualBox VMs is 1.1M, so no virtual disks exist.
remove_group "empty apps" \
    ollama virtualbox virtualbox-host-dkms

# ── 5. orphan sweep, iterated ────────────────────────────────────────
#       Removing the groups above orphans their private dependencies,
#       and removing those can orphan more. Loop until stable.
note "orphan sweep"
round=0
while true; do
    mapfile -t orphans < <(pacman -Qdtq 2>/dev/null)
    (( ${#orphans[@]} == 0 )) && { ok "no orphans left after $round round(s)"; break; }
    round=$((round+1))
    if (( round > 10 )); then warn "stopping after 10 rounds"; break; fi
    printf '   round %d: %d orphans\n' "$round" "${#orphans[@]}"
    pacman -Rns "${orphans[@]}" || { warn "orphan removal failed; stopping sweep"; break; }
done

# ── 6. GPU: Integrated -> Hybrid ─────────────────────────────────────
#       The user wants the dGPU idle-but-wakeable. Integrated removes the
#       card from the PCI bus entirely, so it cannot wake; Hybrid keeps it
#       present, runtime-suspended, and available via prime-run.
note "GPU mode: Integrated -> Hybrid"
if command -v supergfxctl >/dev/null; then
    printf '   current: %s\n' "$(supergfxctl -g 2>/dev/null)"
    if supergfxctl -m Hybrid 2>&1 | sed 's/^/   /'; then
        ok "requested Hybrid — a reboot or re-login is required to apply"
    else
        warn "mode switch failed; staying on $(supergfxctl -g 2>/dev/null)"
    fi
else
    warn "supergfxctl not found"
fi

# ── 7. report ────────────────────────────────────────────────────────
AFTER_EXPLICIT=$(pacman -Qqe | wc -l)
AFTER_TOTAL=$(pacman -Q | wc -l)
note "RESULT"
printf '   explicit: %s -> %s\n' "$BEFORE_EXPLICIT" "$AFTER_EXPLICIT"
printf '   total:    %s -> %s\n' "$BEFORE_TOTAL" "$AFTER_TOTAL"
printf '   orphans:  %s\n' "$(pacman -Qdtq 2>/dev/null | wc -l)"
printf '   root fs:  %s\n' "$(df -h / | awk 'NR==2{print $3" used, "$4" avail"}')"

cat <<'EOF'

══════════════════════════════════════════════════════════════════════
Next: reboot to apply the Hybrid GPU mode.

After rebooting, verify with:
    supergfxctl -g                 # should say Hybrid
    lsmod | grep -c '^nvidia'      # should be > 0 now
    prime-run glxinfo | grep -i vendor   # should report NVIDIA

Then measure the battery cost on BATTERY (not AC) with:
    bash docs/migration/measure-battery.sh

snap-pac took a snapshot before every transaction above, so any single
step is revertible from the GRUB snapshot menu.
══════════════════════════════════════════════════════════════════════
EOF
