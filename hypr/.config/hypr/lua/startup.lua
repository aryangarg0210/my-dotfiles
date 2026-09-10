-- Autostart. Replaces configs/Startup_Apps.conf + UserConfigs/Startup_Apps.conf.
-- `exec-once = foo` becomes an hl.exec_cmd inside the hyprland.start handler.
local d = require("lua.defaults")

hl.on("hyprland.start", function()
    -- initial boot: applies wallpaper/theme once, guarded by
    -- ~/.config/hypr/.initial_startup_done
    hl.exec_cmd(d.hypr .. "/initial-boot.sh")

    -- wallpaper daemon
    hl.exec_cmd("awww-daemon --format xrgb")

    -- session environment
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    hl.exec_cmd(d.scripts .. "/Polkit.sh")

    -- notification daemon
    hl.exec_cmd("swaync")

    -- bar on eDP-1 (laptop screen)
    hl.exec_cmd("waybar -c " .. d.home .. "/.config/waybar/config")

    hl.exec_cmd("hypridle")
    hl.exec_cmd(d.scripts .. "/Hyprsunset.sh init")

    -- clipboard manager
    hl.exec_cmd("clipse -listen")

    hl.exec_cmd("rog-control-center")

    -- layout-aware keybinds (was also in configs/Keybinds.conf)
    hl.exec_cmd(d.scripts .. "/KeybindsLayoutInit.sh")
    hl.exec_cmd(d.scripts .. "/ChangeLayout.sh init")

    -- keyd layer -> ASUS aura LED colour
    hl.exec_cmd("bash " .. d.home .. "/my-dotfiles/scripts/keyd-aura.sh")
end)

-- ── Disabled by default (kept for reference) ───────────────────────────
-- nm-applet          : waybar has a native network module
-- blueman-applet     : waybar has a native bluetooth module
-- qs -c overview     : ~20% CPU idle; Super+A falls back to AGS
-- WallpaperAutoChange: random wallpaper every 30 min
