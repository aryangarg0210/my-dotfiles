-- Default keybinds. Replaces configs/Keybinds.conf.
local d = require("lua.defaults")

local mod  = d.mainMod
local S    = d.scripts
local US   = d.user_scripts

-- small helper: hl.bind(keys, dispatcher, { description = desc })
local function bind(keys, dispatcher, desc, flags)
    flags = flags or {}
    flags.description = desc
    hl.bind(keys, dispatcher, flags)
end
local function exec(cmd) return hl.dsp.exec_cmd(cmd) end

-- ── COMMON ─────────────────────────────────────────────────────────────
bind(mod .. " + D", exec("pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window"), "app launcher")
bind(mod .. " + B", exec('xdg-open "https://"'), "open default browser")
bind(mod .. " + A", exec(S .. "/OverviewToggle.sh"), "desktop overview")
bind(mod .. " + Return", exec(d.term), "Open terminal")
bind(mod .. " + E", exec(d.files), "file manager")

-- ── FEATURES / EXTRAS ──────────────────────────────────────────────────
bind(mod .. " + T", exec(S .. "/ThemeChanger.sh"), "Global theme switcher using Wallust")
bind(mod .. " + H", exec(S .. "/KeyHints.sh"), "help / cheat sheet")
bind(mod .. " + ALT + R", exec(S .. "/Refresh.sh"), "refresh bar and menus")
bind(mod .. " + ALT + E", exec(S .. "/RofiEmoji.sh"), "emoji menu")
bind(mod .. " + S", exec(S .. "/RofiSearch.sh"), "web search")
bind(mod .. " + CTRL + S", exec("rofi -show window"), "window switcher")
bind(mod .. " + ALT + O", exec(S .. "/ChangeBlur.sh"), "toggle blur")
bind(mod .. " + SHIFT + G", exec(S .. "/GameMode.sh"), "toggle game mode")
bind(mod .. " + ALT + L", exec(S .. "/ChangeLayout.sh"), "toggle master/dwindle layout")
bind(mod .. " + ALT + V", exec(d.term .. " --class=com.clipse.Clipboard -e clipse"), "clipboard manager")
bind(mod .. " + ALT + N", exec(d.term .. " --class=com.ghostty.WiFi -e " .. S .. "/WifiConnect.sh"), "wifi manager")
bind(mod .. " + CTRL + R", exec(S .. "/RofiThemeSelector.sh"), "rofi theme selector")
bind(mod .. " + CTRL + SHIFT + R", exec("pkill rofi || true && " .. S .. "/RofiThemeSelector-modified.sh"), "rofi theme selector (modified)")

bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen(), "fullscreen")
bind(mod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized" }), "maximize window")
bind(mod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }), "Float current window")
-- `workspaceopt allfloat` no longer exists; same effect, done in Lua.
bind(mod .. " + ALT + SPACE", function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
        hl.dispatch(hl.dsp.window.float({ action = "toggle", window = w }))
    end
end, "Float all windows")
bind(mod .. " + SHIFT + Return", exec(S .. "/Dropterminal.sh " .. d.term), "DropDown terminal")

-- Desktop zoom / magnifier
local function zoom(op)
    return exec("hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | "
        .. "awk 'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor " .. op .. "}')\"")
end
bind(mod .. " + ALT + mouse_down", zoom("* 2.0"), "zoom in")
bind(mod .. " + ALT + mouse_up",   zoom("/ 2.0"), "zoom out")

-- Waybar
bind(mod .. " + CTRL + ALT + B", exec("pkill -SIGUSR1 waybar"), "toggle waybar on/off")
bind(mod .. " + CTRL + B", exec(S .. "/WaybarStyles.sh"), "waybar styles menu")
bind(mod .. " + ALT + B", exec(S .. "/WaybarLayout.sh"), "waybar layout menu")

-- Night light
bind(mod .. " + N", exec(S .. "/Hyprsunset.sh toggle"), "toggle night light")

-- UserScripts
bind(mod .. " + SHIFT + M", exec(US .. "/RofiBeats.sh"), "online music")
bind(mod .. " + W", exec(US .. "/WallpaperSelect.sh"), "select wallpaper")
bind(mod .. " + SHIFT + W", exec(US .. "/WallpaperEffects.sh"), "wallpaper effects")
bind("CTRL + ALT + W", exec(US .. "/WallpaperRandom.sh"), "random wallpaper")
bind(mod .. " + CTRL + O", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }), "toggle active window opacity")
bind(mod .. " + SHIFT + K", exec(S .. "/KeyBinds.sh"), "search keybinds")
bind(mod .. " + SHIFT + A", exec(S .. "/Animations.sh"), "animations menu")
bind(mod .. " + SHIFT + O", exec(US .. "/ZshChangeTheme.sh"), "change oh-my-zsh theme")
bind("ALT + SHIFT_L", exec(S .. "/KeyboardLayout.sh switch"), "switch keyboard layout globally",
     { locked = true, non_consuming = true })
bind("SHIFT + ALT_L", exec(S .. "/Tak0-Per-Window-Switch.sh"), "switch keyboard layout per-window",
     { locked = true, non_consuming = true })
bind(mod .. " + ALT + C", exec(US .. "/RofiCalc.sh"), "calculator")

-- Move current workspace between monitors
bind(mod .. " + CTRL + F9",  hl.dsp.workspace.move({ monitor = "l" }), "move workspace to left monitor")
bind(mod .. " + CTRL + F10", hl.dsp.workspace.move({ monitor = "r" }), "move workspace to right monitor")
bind(mod .. " + CTRL + F11", hl.dsp.workspace.move({ monitor = "u" }), "move workspace to up monitor")
bind(mod .. " + CTRL + F12", hl.dsp.workspace.move({ monitor = "d" }), "move workspace to down monitor")

-- ── SYSTEM ─────────────────────────────────────────────────────────────
bind("CTRL + ALT + Delete", hl.dsp.exit(), "exit Hyprland")
bind(mod .. " + Q", hl.dsp.window.close(), "close active window")
bind(mod .. " + SHIFT + Q", exec(S .. "/KillActiveProcess.sh"), "Terminate active process")
bind("CTRL + ALT + L", exec(S .. "/LockScreen.sh"), "lock screen")
bind("CTRL + ALT + P", exec(S .. "/Wlogout.sh"), "powermenu")
bind(mod .. " + SHIFT + N", exec("swaync-client -t -sw"), "notification panel")
bind(mod .. " + SHIFT + E", exec(S .. "/Kool_Quick_Settings.sh"), "Quick settings menu")

-- ── LAYOUTS ────────────────────────────────────────────────────────────
bind(mod .. " + CTRL + D", hl.dsp.layout("removemaster"), "remove master")
bind(mod .. " + I", hl.dsp.layout("addmaster"), "add master")
bind(mod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"), "swap with master")
-- NOTE: J/K are bound dynamically by scripts/KeybindsLayoutInit.sh and
-- scripts/ChangeLayout.sh, deliberately not bound statically here.
bind(mod .. " + SHIFT + I", hl.dsp.layout("togglesplit"), "toggle split (dwindle)")
bind(mod .. " + P", hl.dsp.window.pseudo(), "toggle pseudo (dwindle)")
bind(mod .. " + M", hl.dsp.layout("splitratio 0.3"), "set split ratio 0.3")

-- Cycle windows; if floating, bring to top.
-- Two separate binds on one key in hyprlang -> one lambda in Lua.
bind("ALT + tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end, "cycle next window / bring active to top")

-- ── SPECIAL / MEDIA KEYS ───────────────────────────────────────────────
bind("XF86AudioRaiseVolume", exec(S .. "/Volume.sh --inc"), "volume up", { repeating = true, locked = true })
bind("XF86AudioLowerVolume", exec(S .. "/Volume.sh --dec"), "volume down", { repeating = true, locked = true })
bind("ALT + XF86AudioRaiseVolume", exec(S .. "/Volume.sh --inc-precise"), "volume up precise", { repeating = true, locked = true })
bind("ALT + XF86AudioLowerVolume", exec(S .. "/Volume.sh --dec-precise"), "volume down precise", { repeating = true, locked = true })
bind("XF86AudioMicMute", exec(S .. "/Volume.sh --toggle-mic"), "toggle mic mute", { locked = true })
bind("XF86AudioMute", exec(S .. "/Volume.sh --toggle"), "toggle mute", { locked = true })
bind("XF86Sleep", exec("systemctl suspend"), "sleep", { locked = true })
bind("XF86RFKill", exec(S .. "/AirplaneMode.sh"), "airplane mode", { locked = true })

-- NOTE: the old config bound `xf86AudioPlayPause`, which is not a real xkb
-- keysym (see /usr/include/xkbcommon/xkbcommon-keysyms.h) - hyprlang accepted
-- it silently and the bind never fired. Dropped. The physical play/pause key
-- emits XF86AudioPlay, which is bound below to the same action.
bind("XF86AudioPause",     exec(S .. "/MediaCtrl.sh --pause"), "pause",      { locked = true })
bind("XF86AudioPlay",      exec(S .. "/MediaCtrl.sh --pause"), "play",       { locked = true })
bind("XF86AudioNext",      exec(S .. "/MediaCtrl.sh --nxt"),   "next track", { locked = true })
bind("XF86AudioPrev",      exec(S .. "/MediaCtrl.sh --prv"),   "previous track", { locked = true })
bind("XF86AudioStop",      exec(S .. "/MediaCtrl.sh --stop"),  "stop",       { locked = true })

-- ── SCREENSHOTS ────────────────────────────────────────────────────────
bind(mod .. " + Print", exec(S .. "/ScreenShot.sh --now"), "screenshot now")
bind(mod .. " + SHIFT + Print", exec(S .. "/ScreenShot.sh --area"), "screenshot (area)")
bind(mod .. " + CTRL + Print", exec(S .. "/ScreenShot.sh --in5"), "screenshot in 5s")
bind(mod .. " + CTRL + SHIFT + Print", exec(S .. "/ScreenShot.sh --in10"), "screenshot in 10s")
bind("ALT + Print", exec(S .. "/ScreenShot.sh --active"), "screenshot active window")
bind(mod .. " + SHIFT + S", exec(S .. "/ScreenShot.sh --swappy"), "screenshot (swappy)")

-- ── RESIZE / MOVE / SWAP ───────────────────────────────────────────────
local dirs = { left = "l", right = "r", up = "u", down = "d" }
local resize = { left = {-50, 0}, right = {50, 0}, up = {0, -50}, down = {0, 50} }

for key, delta in pairs(resize) do
    bind(mod .. " + SHIFT + " .. key,
         hl.dsp.window.resize({ x = delta[1], y = delta[2], relative = true }),
         "resize " .. key, { repeating = true })
end

for key, dir in pairs(dirs) do
    bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ direction = dir }), "move window " .. key)
    bind(mod .. " + ALT + "  .. key, hl.dsp.window.swap({ direction = dir }), "swap window " .. key)
    bind(mod .. " + "        .. key, hl.dsp.focus({ direction = dir }),       "focus " .. key)
end

-- ── GROUPS ─────────────────────────────────────────────────────────────
bind(mod .. " + G", hl.dsp.group.toggle(), "toggle group")
bind(mod .. " + Tab", hl.dsp.group.next(), "Change Group Forward")
bind(mod .. " + CTRL + tab", hl.dsp.group.next(), "change active in group")
bind(mod .. " + SHIFT + Tab", hl.dsp.group.prev(), "Change Group Back")
bind(mod .. " + CTRL + K", hl.dsp.window.move({ into_group = "l" }), "Move left into group")
bind(mod .. " + CTRL + L", hl.dsp.window.move({ into_group = "r" }), "Move Right into group")
bind(mod .. " + CTRL + H", hl.dsp.window.move({ out_of_group = true }), "Move active out of group")

-- ── WORKSPACES ─────────────────────────────────────────────────────────
bind(mod .. " + tab", hl.dsp.focus({ workspace = "m+1" }), "next workspace")
bind(mod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }), "previous workspace")

bind(mod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }), "move to special workspace")
bind(mod .. " + U", hl.dsp.workspace.toggle_special(), "toggle special workspace")

-- The old config bound these by keycode (code:10..code:19) so they would
-- survive non-QWERTY layouts. `code:NN` is currently BROKEN in Hyprland
-- 0.56.2's Lua parser - it produces a bind with no key and no keycode, i.e.
-- a dead bind - so these use plain digits instead. With input.kb_layout = "us"
-- the two are equivalent. Re-test `code:` after upgrading to 0.57.
for i = 1, 10 do
    local key = tostring(i % 10) -- 10 -> "0"
    bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }), "workspace " .. i)
    bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "move to workspace " .. i)
    bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }),
         "move silently to workspace " .. i)
end

bind(mod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "-1" }), "move to previous workspace")
bind(mod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }), "move to next workspace")
bind(mod .. " + CTRL + bracketleft",   hl.dsp.window.move({ workspace = "-1", follow = false }), "move silently to previous workspace")
bind(mod .. " + CTRL + bracketright",  hl.dsp.window.move({ workspace = "+1", follow = false }), "move silently to next workspace")

bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "next workspace")
bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), "previous workspace")
bind(mod .. " + period",     hl.dsp.focus({ workspace = "e+1" }), "next workspace")
bind(mod .. " + comma",      hl.dsp.focus({ workspace = "e-1" }), "previous workspace")

-- ── MOUSE ──────────────────────────────────────────────────────────────
bind(mod .. " + mouse:272", hl.dsp.window.drag(),   "move window",   { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), "resize window", { mouse = true })
