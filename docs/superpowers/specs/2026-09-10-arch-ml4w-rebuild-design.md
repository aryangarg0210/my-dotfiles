# Arch + ML4W rebuild — design

**Date:** 2026-09-10
**Branch:** `feat/v2`
**Baseline commit:** `554a399` (checkpoint of all pre-rebuild work)

## Goal

Replace a broken, half-maintained Hyprland config tree with a maintained
Lua-native base (ML4W), on the existing Arch install, keeping VS Code,
Neovim, Zen Browser and the zsh shortcuts.

## Premises, corrected by measurement

Three assumptions behind the original request did not survive checking.

**Arch is already current.** A full system upgrade ran 2026-09-10 14:04 and
`checkupdates` returns 0. Arch is rolling and has no versions; an ISO is a
snapshot of the *installer*, not of the system. A fresh install from today's
ISO lands on the same packages already running. No reinstall is performed.

**The bloat is in `$HOME`, not in root.** `/home` is 221G — `.local` 37G,
`Desktop` 35G, `Downloads` 34G — against 32 orphaned packages and 51 AUR
packages on root. A root reinstall preserves `@home` by design and so would
not have touched the actual bulk.

**JaKooLit is dead.** `JaKooLit/Hyprland-Dots` last pushed 2026-02-22; its
README hands the project to `LinuxBeginnings` from March 2026. It never
migrated to Lua. This is the most likely root cause of the breakage.

## The forcing function

Hyprland 0.55 deprecated hyprlang; `.conf` support is removed in **0.57**.
Current system is 0.56.2 (released 2026-08-05), so 0.57 is imminent.

This config is **already migrated and live**:

```
[cfg] Using lua config found at /home/aryan/.config/hypr/hyprland.lua
Hyprland --verify-config → config ok
```

Adopting any `.conf`-based dotfiles would be a regression. This is why
`LinuxBeginnings` (still shipping `hyprland.lua.disable`) was rejected
despite being the JaKooLit successor.

Note: `hypridle`, `hyprlock` and `hyprpaper` are separate binaries that keep
hyprlang. Their `.conf` files are **not** affected by the 0.57 removal.

## Base selection

| Project | Lua | Activity | Stars | Verdict |
|---|---|---|---|---|
| JaKooLit | no | dead (Feb 2026) | 3.5k | abandoned |
| LinuxBeginnings | `.disable` only | daily | 206 | Lua not live; too small a bet |
| Omarchy | full | daily | 39.9k | whole distro; fights keyd/supergfxctl/dual-GPU |
| end-4 | full | Aug 27 | 16k | heaviest (Quickshell/QML) |
| **ML4W 2.15.1** | **full** | **Aug 27** | **5k** | **chosen** |

ML4W is a configured desktop rather than a distro, is fully Lua
(`hyprland.lua`, `input.lua`, `workspaces.lua`, `colors.lua`), has no
`hyprland.conf` left, and carries a `restore[]` mechanism for preserving user
files across updates.

## Risk model

Only **unbootable** or **netless** counts as breakage. A drop to a TTY with
tmux and Claude Code is an acceptable working state, since both are CLI.

Existing safety already present: two kernels installed and both in GRUB —
`linux 7.2.4.arch1-2` and `linux-lts 6.18.50-2` (currently booted).

### The sharp edge

`linux-firmware` is split by vendor on this system.
`linux-firmware-mediatek` supplies the firmware for the MT7921 wifi adapter.
An orphan sweep would remove it; the machine would boot perfectly with no
wifi, and therefore no way to fetch a fix. It is pinned explicitly.

### The symlink hazard

All 8 config paths that ML4W collides with are stow symlinks into this repo:

```
~/.config/hypr   -> ../my-dotfiles/hypr/.config/hypr
~/.config/waybar -> ../my-dotfiles/waybar/.config/waybar
~/.zshrc         -> my-dotfiles/zsh/.zshrc
```

ML4W's installer writing to `~/.config/hypr/hyprland.lua` would follow the
symlink and rewrite files **inside the git repo**, silently. Unstowing must
therefore precede the ML4W install.

Colliding (8): `hypr waybar rofi swaync wlogout kitty fastfetch zsh`
Safe (11): `cliphist clipse ghostty layers mpd nvim rmpc scripts spicetify starship tmux`

## Ordering: additive first, subtractive last

Packages are installed before anything is removed, so every phase retains a
working browser, network and terminal, and the one risky step runs last —
after ML4W is known to boot.

Configs are the exception: they are cleared *before* ML4W installs. Installing
onto the old tree would yield a hybrid, which is the breakage being escaped.

The cost of this ordering is a fat intermediate state where both the old
package set and ML4W's are installed. "No previous packages" is reached at
phase 4, not before.

## Phases

### Phase 0 — Escape hatches

- `snapper` + `snap-pac` + `grub-btrfs`; configs for `@` and `@home`
- One named pre-purge snapshot, with a GRUB entry that boots it
- Rescue Lua config at `~/.config/hypr-rescue/hyprland.lua`, validated
- Confirm tmux + Claude Code work on a bare TTY

Requires root. Rescue config does not.

### Phase 1 — Preserve keepers

- Push `feat/v2` to GitHub (off-machine copy of the checkpoint)
- Copy `~/.ssh`, `~/.gnupg`, `~/.config/gh` to the idle 476G `DATA` disk
- Extract zsh shortcuts to a standalone, ML4W-independent fragment
- Export `pacman -Qqe` and `pacman -Qm`

### Phase 2 — Break the symlink hazard

- `stow -D` the 8 colliding packages only
- Move those `~/.config` dirs to `~/.config-old-2026-09-10/`
- Nothing is deleted; the repo becomes untouchable by the installer

### Phase 3 — ADD: install ML4W

- `bash <(curl -s https://ml4w.com/os/stable)` → 2.15.1
- Nothing removed yet
- Log into stock ML4W and use it before customizing

### Phase 4 — SUBTRACT: purge

- Mark all explicit packages `--asdeps`
- Re-mark the keep-list `--asexplicit`
- `pacman -Rns $(pacman -Qqdt)` — roughly 1326 → ~400

Pinned: `base linux linux-lts linux-firmware-mediatek linux-firmware-amdgpu
mkinitcpio grub efibootmgr amd-ucode btrfs-progs systemd networkmanager
wpa_supplicant sudo openssh zsh visual-studio-code-bin neovim zen-browser-bin`

Only phase with real risk; runs with ML4W working and a snapshot behind it.

### Phase 5 — Re-layer keepers

- Restow the 11 safe packages
- **Retarget ML4W's terminal from kitty to ghostty** across its configs and
  keybinds
- Reapply the dual-GPU environment deliberately:
  - `LIBVA_DRIVER_NAME=radeonsi` (keeps the dGPU asleep for video)
  - `GSK_RENDERER=ngl`
  - dGPU held off via `supergfxctl` Integrated
  - `AQ_DRM_DEVICES` left commented — an inline `#` comment on that line
    poisoned the device path and caused the June 2026 crash loop. In Lua the
    value is a quoted string, so the trap cannot recur, but the variable
    stays out unless a second GPU is actually needed.

### Phase 6 — Harden the three priorities

- **wifi** — powersave already disabled via
  `/etc/NetworkManager/conf.d/wifi-powersave.conf` (`wifi.powersave = 3`).
  Remaining journal warnings (`p2p-dev` forwarding, `multicast RX
  registrations`) are benign noise, not disconnects.
- **bluetooth** — `bluez` 5.87, service enabled; verify pairing persistence
- **workspaces** — the only genuinely dotfiles-level item of the three;
  rebuild on ML4W's `workspaces.lua`

wifi and bluetooth are service/driver level and were never going to be fixed
by a choice of dotfiles.

### Phase 7 — Repo restructure

Restructure `my-dotfiles` as "ML4W + overlay", using ML4W's `restore[]`
instead of fighting it. Resolve `matugen` (ML4W) vs `wallust` (current) —
running both will contend over colors. Pick one.

## Known gaps

- `layers/` (keyd) lives in `/etc/keyd`, is root-owned and not stowable;
  it survives a config purge untouched but stays outside the stow model
- `cliphist`, `clipse`, `mpd` are deployed as copies, not symlinks
- `stash@{0}` ("post-crash rollback 2026-06-11") predates `554a399` and is
  not included in it; decide to apply or drop before phase 2

## Trade accepted

The repo becomes "ML4W plus my overlay" rather than wholly owned config. In
exchange, someone else maintains the 0.57 migration and everything after it.
Given that JaKooLit died underneath this setup, that is the point.
