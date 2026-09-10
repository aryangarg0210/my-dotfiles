-- Laptop-specific binds + devices. Replaces configs/Laptops.conf,
-- UserConfigs/Laptops.conf and UserConfigs/LaptopDisplay.conf.
local d = require("lua.defaults")
local mod, S = d.mainMod, d.scripts

local function bind(keys, dispatcher, desc, flags)
    flags = flags or {}; flags.description = desc
    hl.bind(keys, dispatcher, flags)
end
local function exec(cmd) return hl.dsp.exec_cmd(cmd) end

-- keyboard backlight
bind("XF86KbdBrightnessDown", exec(S .. "/BrightnessKbd.sh --dec"), "decrease keyboard brightness", { repeating = true })
bind("XF86KbdBrightnessUp",   exec(S .. "/BrightnessKbd.sh --inc"), "increase keyboard brightness", { repeating = true })

-- ASUS hardware keys
bind("XF86Launch1", exec("rog-control-center"),   "ASUS Armory Crate button")
bind("XF86Launch3", exec("asusctl led-mode -n"),  "FN+F4 switch keyboard RGB profile")
bind("XF86Launch4", exec("asusctl profile -n"),   "FN+F5 change fan profile")

-- display backlight
bind("XF86MonBrightnessDown", exec(S .. "/Brightness.sh --dec"), "decrease monitor brightness", { repeating = true })
bind("XF86MonBrightnessUp",   exec(S .. "/Brightness.sh --inc"), "increase monitor brightness", { repeating = true })

bind("XF86TouchpadToggle", exec(S .. "/TouchPad.sh"), "toggle touchpad")

-- Screenshots on F6 (this laptop has no PrintScreen key)
bind(mod .. " + F6",           exec(S .. "/ScreenShot.sh --now"),    "screenshot")
bind(mod .. " + SHIFT + F6",   exec(S .. "/ScreenShot.sh --area"),   "screenshot (area)")
bind(mod .. " + CTRL + F6",    exec(S .. "/ScreenShot.sh --in5"),    "screenshot (5s delay)")
bind(mod .. " + ALT + F6",     exec(S .. "/ScreenShot.sh --in10"),   "screenshot (10s delay)")
bind("ALT + F6",               exec(S .. "/ScreenShot.sh --active"), "screenshot (active window)")

-- Touchpad device
hl.device({
    name    = d.touchpad_device,
    enabled = d.touchpad_enabled,
})

-- ── Lid switch (disabled, as in the old config) ────────────────────────
-- Uncomment to turn the internal display off when the lid closes:
--   hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd('hyprctl keyword monitor "eDP-1, disable"'), { locked = true })
--   hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd('hyprctl keyword monitor "eDP-1, preferred, auto, 1"'), { locked = true })
-- Caveat from the old config: make sure the lid is OPEN before shutting down,
-- otherwise the internal panel may not come back.
