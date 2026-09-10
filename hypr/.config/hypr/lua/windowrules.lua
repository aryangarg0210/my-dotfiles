-- Window + layer rules (vendor defaults). Replaces configs/WindowRules.conf.
-- Rules are evaluated top to bottom; order matters.

-- ── TAGS ───────────────────────────────────────────────────────────────
-- Tag apps once, then drive behaviour off the tag.
local tags = {
    browser = {
        "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$",
        "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
        "^(chrome-.+-Default)$",
        "^([Cc]hromium)$",
        "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$",
        "^(Brave-browser(-beta|-dev|-unstable)?)$",
        "^([Tt]horium-browser|[Cc]achy-browser)$",
        "^(zen-alpha|zen)$",
    },
    notif        = { "^(swaync-control-center|swaync-notification-window|swaync-client|class)$" },
    terminal     = { "^(Alacritty|kitty|kitty-dropterm|com.mitchellh.ghostty)$" },
    email        = {
        "^([Tt]hunderbird|org.mozilla.Thunderbird)$",
        "^(eu.betterbird.Betterbird)$",
        "^(org.gnome.Evolution)$",
    },
    projects = {
        "^(codium|codium-url-handler|VSCodium)$",
        "^(VSCode|code|code-url-handler)$",
        "^(jetbrains-.+)$",
        "^(dev.zed.Zed|antigravity)$",
    },
    screenshare  = { "^(com.obsproject.Studio)$" },
    im = {
        "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$",
        "^([Ff]erdium)$",
        "^([Ww]hatsapp-for-linux)$",
        "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$",
        "^(teams-for-linux)$",
        "^(im.riot.Riot|Element)$",
    },
    games        = { "^(gamescope)$", "^(steam_app_\\d+)$" },
    gamestore    = { "^([Ss]team)$", "^(com.heroicgameslauncher.hgl)$" },
    ["file-manager"] = { "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$", "^(app.drey.Warp)$" },
    wallpaper    = { "^([Ww]aytrogen)$" },
    multimedia   = { "^([Aa]udacious)$" },
    multimedia_video = { "^([Mm]pv|vlc)$" },
    settings = {
        "^(wihotspot(-gui)?)$",
        "^([Bb]aobab|org.gnome.[Bb]aobab)$",
        "^(gnome-disks|wihotspot(-gui)?)$",
        "^(file-roller|org.gnome.FileRoller)$",
        "^(nm-applet|nm-connection-editor|blueman-manager)$",
        "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        "^(qt5ct|qt6ct)$",
        "(xdg-desktop-portal-gtk)",
        "^(org.kde.polkit-kde-authentication-agent-1)$",
        "^([Rr]ofi)$",
        "^(btrfs-assistant)$",
        "^(timeshift-gtk)$",
    },
    viewer = {
        "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
        "^(evince)$",
        "^(eog|org.gnome.Loupe)$",
    },
    ["KooL-Settings"] = { "^(nwg-displays|nwg-look)$" },
}

for tag, classes in pairs(tags) do
    for _, class in ipairs(classes) do
        hl.window_rule({ match = { class = class }, tag = "+" .. tag })
    end
end

-- tags matched on title rather than class
hl.window_rule({ match = { title = "^(KooL Quick Cheat Sheet)$" }, tag = "+KooL_Cheat" })
hl.window_rule({ match = { title = "^(KooL Hyprland Settings)$" }, tag = "+KooL_Settings" })
hl.window_rule({ match = { title = "^([Ll]utris)$" },              tag = "+gamestore" })
hl.window_rule({ match = { title = "^(ROG Control)$" },            tag = "+settings" })
hl.window_rule({ match = { title = "(Kvantum Manager)" },          tag = "+settings" })

-- ── OVERRIDES ──────────────────────────────────────────────────────────
hl.window_rule({ match = { tag = "multimedia_video" }, no_blur = true, opacity = "1.0" })
hl.window_rule({ match = { tag = "multimedia" },       no_blur = true, opacity = "1.0" })

-- ── POSITION ───────────────────────────────────────────────────────────
hl.window_rule({ match = { tag = "KooL_Cheat" },    center = true })
hl.window_rule({ match = { tag = "KooL-Settings" }, center = true })
hl.window_rule({ match = { title = "^(ROG Control)$" }, center = true })
hl.window_rule({ match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({ match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, center = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, center = true })

-- ── IDLE INHIBIT ───────────────────────────────────────────────────────
-- Don't idle while a window is fullscreen.
-- NOTE: the old config had three more idle_inhibit lines matching `^(*)$`
-- and `match:fullscreen 1`. `^(*)$` is an invalid regex (nothing to repeat)
-- so those were silent no-ops, and `fullscreen 1` duplicated this rule.
-- Dropped - behaviour is unchanged.
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })

-- ── FLOAT ──────────────────────────────────────────────────────────────
hl.window_rule({ match = { tag = "KooL_Cheat" },    float = true })
hl.window_rule({ match = { tag = "wallpaper" },     float = true, center = true })
hl.window_rule({ match = { tag = "settings" },      float = true, center = true })
hl.window_rule({ match = { tag = "viewer" },        float = true, center = true })
hl.window_rule({ match = { tag = "KooL-Settings" }, float = true, center = true })

hl.window_rule({ match = { class = "([Zz]oom|onedriver|onedriver-launcher)" },  float = true })
hl.window_rule({ match = { class = "(org.gnome.Calculator|qalculate-gtk)" },    float = true })
hl.window_rule({ match = { class = "^(mpv|com.github.rafostar.Clapper)$" },     float = true })
hl.window_rule({ match = { class = "^([Qq]alculate-gtk)$" },                    float = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" },                          float = true })

hl.window_rule({
    match = { class = "^(com.clipse.Clipboard)$" },
    float = true, center = true, size = { "monitor_w*0.4", "monitor_h*0.5" },
})
hl.window_rule({
    match = { class = "^(com.ghostty.WiFi)$" },
    float = true, center = true, size = { "monitor_w*0.35", "monitor_h*0.5" },
})
hl.window_rule({
    match = { class = "^(com.waybar.SysMonitor)$" },
    float = true, center = true, size = { "monitor_w*0.6", "monitor_h*0.6" },
})

-- ── POPUPS & DIALOGUES ─────────────────────────────────────────────────
hl.window_rule({ match = { title = "^(Authentication Required)$" }, float = true, center = true })
hl.window_rule({
    match = { class = "(codium|codium-url-handler|VSCodium)", title = "negative:(.*codium.*|.*VSCodium.*)" },
    float = true,
})
hl.window_rule({
    match = { class = "^(com.heroicgameslauncher.hgl)$", title = "negative:(Heroic Games Launcher)" },
    float = true,
})
hl.window_rule({ match = { class = "^([Ss]team)$", title = "negative:^([Ss]team)$" }, float = true })
hl.window_rule({
    match = { title = "^(Add Folder to Workspace)$" },
    float = true, center = true, size = { "monitor_w*0.7", "monitor_h*0.6" },
})
hl.window_rule({
    match = { title = "^(Save As)$" },
    float = true, center = true, size = { "monitor_w*0.7", "monitor_h*0.6" },
})
hl.window_rule({
    match = { initial_title = "(Open Files)" },
    float = true, size = { "monitor_w*0.7", "monitor_h*0.6" },
})
hl.window_rule({
    match = { title = "^(SDDM Background)$" },
    float = true, center = true, size = { "monitor_w*0.16", "monitor_h*0.12" },
})
hl.window_rule({
    match = { class = "^(yad)$" },
    float = true, center = true, size = { "monitor_w*0.2", "monitor_h*0.2" },
})
hl.window_rule({ match = { class = "^(hyprland-donate-screen)$" }, float = true, center = true })

-- ── OPACITY ────────────────────────────────────────────────────────────
hl.window_rule({ match = { tag = "browser" },      opacity = "0.99 0.95" })
hl.window_rule({ match = { tag = "projects" },     opacity = "0.95 0.95" })
hl.window_rule({ match = { tag = "im" },           opacity = "0.95 0.95" })
hl.window_rule({ match = { tag = "multimedia" },   opacity = "0.95 0.95" })
hl.window_rule({ match = { tag = "file-manager" }, opacity = "0.95 0.95" })
hl.window_rule({ match = { tag = "terminal" },     opacity = "0.95 0.95" })
hl.window_rule({ match = { tag = "settings" },     opacity = "0.95 0.95" })
hl.window_rule({ match = { tag = "viewer" },       opacity = "0.95 0.95" })
hl.window_rule({ match = { tag = "wallpaper" },    opacity = "0.95 0.95" })
hl.window_rule({ match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = "0.95 0.95" })
hl.window_rule({ match = { class = "^(deluge)$" },   opacity = "0.95 0.95" })
hl.window_rule({ match = { class = "^(seahorse)$" }, opacity = "0.95 0.95" })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, opacity = "0.95 0.95" })

-- ── SIZE ───────────────────────────────────────────────────────────────
hl.window_rule({ match = { tag = "KooL_Cheat" }, size = { "monitor_w*0.65", "monitor_h*0.9" } })
hl.window_rule({ match = { tag = "wallpaper" },  size = { "monitor_w*0.7",  "monitor_h*0.7" } })
hl.window_rule({ match = { tag = "settings" },   size = { "monitor_w*0.7",  "monitor_h*0.7" } })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, size = { "monitor_w*0.6", "monitor_h*0.7" } })

-- ── BLUR & FULLSCREEN ──────────────────────────────────────────────────
-- (the old config had this rule twice, verbatim; merged)
hl.window_rule({ match = { tag = "games" }, no_blur = true, fullscreen = false })

-- Don't steal focus from the IntelliJ hover popups
hl.window_rule({ match = { class = "^(jetbrains-.*)$" }, no_initial_focus = true })
hl.window_rule({ match = { title = "^(wind.*)$" },       no_initial_focus = true })

-- ── LAYER RULES ────────────────────────────────────────────────────────
hl.layer_rule({ match = { namespace = "rofi" },                 blur = true })
hl.layer_rule({ match = { namespace = "notifications" },        blur = true })
hl.layer_rule({ match = { namespace = "quickshell:overview" },  blur = true, ignore_alpha = 0.5 })

-- ── NAMED RULES ────────────────────────────────────────────────────────
hl.window_rule({
    name  = "Whatsapp-zapzap",
    match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" },
    size   = { "monitor_w*0.6", "monitor_h*0.7" },
    center = true,
})

hl.window_rule({
    name  = "Picture-in-Picture",
    match = { title = "^(Picture-in-Picture)$" },
    float             = true,
    move              = { "72%", "7%" },
    opacity           = "0.95 0.95",
    pin               = true,
    keep_aspect_ratio = true,
    size              = { "monitor_w*0.3", "monitor_h*0.3" },
})

-- Thunar copy progress dialog
hl.window_rule({
    name  = "Thunar-Progress-bar",
    match = { class = "^(thunar)$", title = "^(File Operation Progress)$" },
    float  = true,
    center = true,
    size   = { "monitor_w*0.26", "monitor_h*0.18" },
})
