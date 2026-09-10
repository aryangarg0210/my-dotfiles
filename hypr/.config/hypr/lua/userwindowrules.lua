-- User window + layer rules. Replaces UserConfigs/WindowRules.conf.
-- This file is yours; vendor defaults live in lua/windowrules.lua.

-- Overskride (bluetooth) - float centered as a popup
hl.window_rule({
    match  = { class = "^[Oo]verskride" },
    float  = true,
    center = true,
    size   = { 480, 560 },
})

-- ── Frosted waybar + swaync (liquid-glass look) ────────────────────────
hl.layer_rule({ match = { namespace = "^(waybar)$" }, blur = true, ignore_alpha = 0.6, xray = true })
hl.layer_rule({ match = { namespace = "^(swaync-control-center)$" }, blur = true, ignore_alpha = 0.5, xray = true })
hl.layer_rule({ match = { namespace = "^(swaync-notification-window)$" }, blur = true, ignore_alpha = 0.5 })
