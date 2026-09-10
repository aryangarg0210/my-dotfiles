-- Core Hyprland settings. Replaces configs/SystemSettings.conf.
local d = require("lua.defaults")

hl.config({
    general = {
        resize_on_border = true,
        layout           = "dwindle",
    },

    dwindle = {
        -- pseudotile was removed upstream in 0.55; the `pseudo` dispatcher
        -- (SUPER+P) still works and is what actually toggles it.
        preserve_split       = true,
        special_scale_factor = 0.8,
    },

    master = {
        new_status = "master",
        new_on_top = true,
        mfact      = 0.5,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        repeat_rate  = 50,
        repeat_delay = 300,

        sensitivity                 = 0,
        numlock_by_default          = true,
        left_handed                 = false,
        follow_mouse                = 1,
        float_switch_override_focus = false,

        touchpad = {
            disable_while_typing    = true,
            natural_scroll          = true,
            clickfinger_behavior    = false,
            middle_button_emulation = false,
            tap_to_click            = true,  -- was `tap-to-click` (hyphen) in hyprlang
            drag_lock               = false,
        },

        touchdevice = {
            enabled = true,
        },

        tablet = {
            transform   = 0,
            left_handed = false,
        },
    },

    -- Only the swipe *tuning* lives in config now; the gestures themselves
    -- are declared with hl.gesture() below.
    gestures = {
        workspace_swipe_distance           = 500,
        workspace_swipe_invert             = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio       = 0.5,
        workspace_swipe_create_new         = true,
        workspace_swipe_forever            = true,
    },

    misc = {
        disable_hyprland_logo      = true,
        disable_splash_rendering   = true,
        vrr                        = 0,
        mouse_move_enables_dpms    = true,
        enable_swallow             = false,
        swallow_regex              = "^(kitty|com.mitchellh.ghostty)$",
        focus_on_activate          = false,
        initial_workspace_tracking = 0,
        middle_click_paste         = false,
        enable_anr_dialog          = true, -- Application Not Responding
        anr_missed_pings           = 15,   -- default of 1 is too low
        allow_session_lock_restore = true, -- avoid lockscreen crash on resume
        -- 0 = no change, 1 = new window takes over fullscreen (Windows-like
        -- alt-tab), 2 = new window stays behind the fullscreen one
        on_focus_under_fullscreen  = 1,
    },

    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles   = true,
        pass_mouse_when_bound    = false,
    },

    -- helps with scaling / avoids pixelation
    xwayland = {
        enabled            = true,
        force_zero_scaling = true,
    },

    render = {
        direct_scanout = 0,
    },

    cursor = {
        sync_gsettings_theme     = true,
        no_hardware_cursors      = 1,
        enable_hyprcursor        = false,
        warp_on_change_workspace = 2,
        no_warps                 = true,
    },
})

-- ── Gestures ───────────────────────────────────────────────────────────
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- 4-finger up/down: desktop zoom in / out.
-- Ported 1:1 from the old shell pipeline. Hyprland now has a native
-- `cursor_zoom` action that does this without shelling out - see notes.
local zoom = function(factor)
    return function()
        hl.dispatch(hl.dsp.exec_cmd(
            "hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | "
            .. "awk 'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor "
            .. factor .. "}')\""))
    end
end

hl.gesture({ fingers = 4, direction = "up",   action = zoom("* 1.5") })
hl.gesture({ fingers = 4, direction = "down", action = zoom("/ 1.5") })

hl.gesture({
    fingers = 3, direction = "up",
    action = function() hl.dispatch(hl.dsp.exec_cmd(d.scripts .. "/OverviewToggle.sh")) end,
})
