-- Decorations. Replaces UserConfigs/UserDecorations.conf.
-- Colours come from wallust (was: source = wallust/wallust-hyprland.conf).
local c = require("lua.colors")

hl.config({
    general = {
        border_size = 2,
        gaps_in     = 2,
        gaps_out    = 4,

        -- was col.active_border / col.inactive_border (dotted hyprlang keys)
        col = {
            active_border   = c.color12,
            inactive_border = c.color10,
        },
    },

    decoration = {
        rounding = 10,

        active_opacity     = 1.0,
        inactive_opacity   = 0.95,
        fullscreen_opacity = 1.0,

        dim_inactive = true,
        dim_strength = 0.1,
        dim_special  = 0.8,

        shadow = {
            enabled        = false,
            range          = 3,
            render_power   = 1,
            color          = c.color12,
            color_inactive = c.color10,
        },

        blur = {
            enabled           = false,
            size              = 5,
            passes            = 2,
            new_optimizations = true,
            xray              = true,
            ignore_opacity    = true,
            special           = false,
            popups            = true,
            vibrancy          = 0.1696,
            noise             = 0.02,
            contrast          = 0.9,
            brightness        = 0.85,
        },
    },

    group = {
        col = {
            border_active = c.color15,
        },
        groupbar = {
            col = {
                active = c.color0,
            },
        },
    },
})
