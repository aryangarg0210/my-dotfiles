-- Animations. Replaces UserConfigs/UserAnimations.conf.

hl.config({ animations = { enabled = true } })

-- was: bezier = name, x1, y1, x2, y2
hl.curve("appleEase",   { type = "bezier", points = { {0.25, 0.1}, {0.25, 1.0} } })
hl.curve("appleSpring", { type = "bezier", points = { {0.50, 0.0}, {0.10, 1.0} } })
hl.curve("appleSnap",   { type = "bezier", points = { {0.20, 0.0}, {0.00, 1.0} } })
hl.curve("liner",       { type = "bezier", points = { {1, 1},      {1, 1}      } })

-- was: animation = leaf, enabled, speed, curve, style
hl.animation({ leaf = "windows",       enabled = true, speed = 4,   bezier = "appleEase",   style = "slide" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4,   bezier = "appleSpring", style = "slide" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 3,   bezier = "appleSnap",   style = "slide" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 4,   bezier = "appleEase",   style = "slide" })
hl.animation({ leaf = "border",        enabled = true, speed = 1,   bezier = "liner" })
-- NOTE: was speed 180 under hyprlang; the Lua schema caps animation speed at
-- 100, so this is clamped. No visible change: borderangle only animates
-- gradient borders, and col.active_border is a solid wallust colour.
hl.animation({ leaf = "borderangle",   enabled = true, speed = 100, bezier = "liner",       style = "loop" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3,   bezier = "appleEase" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 4,   bezier = "appleSpring", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 4,   bezier = "appleSpring", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3,   bezier = "appleSnap",   style = "slide" })
