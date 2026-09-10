-- Environment variables.
-- Replaces configs/ENVariables.conf + UserConfigs/ENVariables.conf.
--
-- NOTE: the old hyprlang `env = KEY,VALUE` swallowed any trailing `# comment`
-- into VALUE, which is what poisoned AQ_DRM_DEVICES and caused the June crash
-- loop. In Lua the value is a quoted string, so a comment can never leak in.
local d = require("lua.defaults")

local env = {
    -- dotfiles version marker
    { "DOTS_VERSION", "2.3.20" },

    -- default editor (was `env = EDITOR,nvim` in 01-UserDefaults.conf)
    { "EDITOR", d.editor },

    -- toolkit backends
    { "GDK_BACKEND",     "wayland,x11,*" },
    { "QT_QPA_PLATFORM", "wayland;xcb" },
    { "CLUTTER_BACKEND", "wayland" },

    -- XDG
    { "XDG_CURRENT_DESKTOP", "Hyprland" },
    { "XDG_SESSION_DESKTOP", "Hyprland" },
    { "XDG_SESSION_TYPE",    "wayland" },

    -- Qt
    { "QT_AUTO_SCREEN_SCALE_FACTOR",       "1" },
    { "QT_WAYLAND_DISABLE_WINDOWDECORATION", "1" },
    { "QT_QPA_PLATFORMTHEME",              "qt6ct" },
    { "QT_QUICK_CONTROLS_STYLE",           "org.hyprland.style" },

    -- xwayland scaling (keep in sync with monitor scale)
    { "GDK_SCALE",       "1" },
    { "QT_SCALE_FACTOR", "1" },

    -- cursor
    { "HYPRCURSOR_THEME", "Bibata-Modern-Ice" },
    { "HYPRCURSOR_SIZE",  "24" },

    -- firefox
    { "MOZ_ENABLE_WAYLAND", "1" },

    -- electron >28
    { "ELECTRON_OZONE_PLATFORM_HINT", "auto" },

    -- GPU: decode/GL pinned to the AMD iGPU so the dGPU stays asleep.
    -- (supergfxctl is in Integrated mode; see project notes.)
    { "LIBVA_DRIVER_NAME", "radeonsi" },
    { "GSK_RENDERER",      "ngl" },
}

for _, e in ipairs(env) do
    hl.env(e[1], e[2])
end

-- ── Disabled by default ────────────────────────────────────────────────
-- Re-enable only if you switch supergfxctl back to Hybrid:
--   hl.env("AQ_DRM_DEVICES", "/dev/dri/by-path/pci-0000:06:00.0-card")
-- NVIDIA-specific (currently unused):
--   hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
--   hl.env("NVD_BACKEND", "direct")
--   hl.env("GBM_BACKEND", "nvidia-drm")
