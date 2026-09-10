-- Your own keybinds. Replaces UserConfigs/UserKeybinds.conf.
-- Loaded AFTER lua/keybinds.lua, exactly like the old source order.
local d = require("lua.defaults")
local mod, S = d.mainMod, d.scripts

local function bind(keys, dispatcher, desc, flags)
    flags = flags or {}; flags.description = desc
    hl.bind(keys, dispatcher, flags)
end
local function exec(cmd) return hl.dsp.exec_cmd(cmd) end

-- ── App -> dedicated workspace ─────────────────────────────────────────
-- `exec, [workspace 10] spotify` becomes exec_cmd's rules table.
bind(mod .. " + M", hl.dsp.exec_cmd("spotify", { workspace = "10" }), "open Spotify on workspace 10")
hl.window_rule({ match = { class = "^(Spotify)$" }, workspace = "10" })

bind(mod .. " + V", hl.dsp.exec_cmd("code", { workspace = "3" }), "open VS Code on workspace 3")
hl.window_rule({ match = { class = "^(Code)$" }, workspace = "3" })

-- ── Quick-app launch row ───────────────────────────────────────────────
bind(mod .. " + SHIFT + F", exec("xdg-open about:blank"), "browser")
bind(mod .. " + SHIFT + E", exec(d.files), "file manager")

-- ── Screenshot to clipboard (no file saved) ────────────────────────────
bind("CTRL + Print", exec('grim -g "$(slurp)" - | wl-copy'), "screenshot area to clipboard")
bind(mod .. " + CTRL + SHIFT + Print", exec("grim - | wl-copy"), "screenshot full to clipboard")

-- ── Fine volume / brightness (1% steps while holding Ctrl) ─────────────
bind("CTRL + XF86AudioRaiseVolume", exec("pactl set-sink-volume @DEFAULT_SINK@ +1%"), "volume +1%", { repeating = true })
bind("CTRL + XF86AudioLowerVolume", exec("pactl set-sink-volume @DEFAULT_SINK@ -1%"), "volume -1%", { repeating = true })
bind("CTRL + XF86MonBrightnessUp",   exec("brightnessctl set +1%"), "brightness +1%", { repeating = true })
bind("CTRL + XF86MonBrightnessDown", exec("brightnessctl set 1%-"), "brightness -1%", { repeating = true })

-- ── Smart gaps ─────────────────────────────────────────────────────────
-- w[tv1] = workspace with one tiled visible window
-- f[1]   = workspace with one fullscreen window
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

-- ── Passthrough submap for VMs (disabled, as before) ───────────────────
-- hl.bind(mod .. " + ALT + P", hl.dsp.submap("passthru"))
-- hl.define_submap("passthru", function()
--     hl.bind(mod .. " + ALT + P", hl.dsp.submap("reset"))
-- end)
