-- User default apps / paths.
-- Replaces UserConfigs/01-UserDefaults.conf and the $var blocks that were
-- repeated at the top of nearly every old .conf file.
local home = os.getenv("HOME")

return {
    home         = home,
    hypr         = home .. "/.config/hypr",
    scripts      = home .. "/.config/hypr/scripts",
    user_scripts = home .. "/.config/hypr/UserScripts",
    user_configs = home .. "/.config/hypr/UserConfigs",

    mainMod = "SUPER",

    -- default apps (were $term / $files / $ide / $music)
    term   = "ghostty",
    files  = "thunar",
    ide    = "antigravity",
    music  = "spotify",
    editor = os.getenv("EDITOR") or "nvim",
    edit   = os.getenv("EDITOR") or "nano",

    search_engine = "https://www.google.com/search?q={}",

    -- was $Touchpad_Device in configs/Laptops.conf
    touchpad_device  = "asue1209:00-04f3:319f-touchpad",
    touchpad_enabled = true,
}
