#!/usr/bin/env bash
# Compatibility shim for Hyprland's two config parsers.
#
# Hyprland 0.55 deprecated hyprlang (.conf) in favour of Lua, and removes it in
# 0.57. The runtime API changed with it:
#
#   legacy (.conf) : `hyprctl keyword ...`  works, `hyprctl eval` is refused
#   lua (.lua)     : `hyprctl eval ...`     works, `hyprctl keyword` is refused
#
# These helpers detect which parser is live and use the right one, so the
# scripts keep working whether hyprland.lua is in place or you've rolled back
# to hyprland.conf.

# Returns 0 if the running compositor uses the Lua config manager.
hypr_uses_lua() {
    if [ -z "${_HYPR_LUA:-}" ]; then
        # NOTE: hyprctl exits 0 even when it refuses the command, so the exit
        # status tells us nothing - we have to read the output. Under the lua
        # parser `eval` answers "ok"; under legacy it answers
        # "eval is only supported with the lua config manager".
        if [ "$(hyprctl eval 'return 1' 2>&1)" = "ok" ]; then _HYPR_LUA=1; else _HYPR_LUA=0; fi
        export _HYPR_LUA
    fi
    [ "$_HYPR_LUA" = "1" ]
}

# Render a lua literal: numbers and booleans bare, everything else quoted.
_hypr_lua_value() {
    local v="$1"
    if [[ "$v" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] || [ "$v" = "true" ] || [ "$v" = "false" ]; then
        printf '%s' "$v"
    else
        printf '"%s"' "${v//\"/\\\"}"
    fi
}

# decoration:blur:size 5  ->  hl.config({ decoration = { blur = { size = 5 } } })
_hypr_lua_config_call() {
    local path="$1" value="$2"
    local -a parts
    IFS=':' read -ra parts <<< "$path"
    local n=${#parts[@]}
    local open="" close=""
    local i
    for ((i = 0; i < n - 1; i++)); do
        open+="{ ${parts[i]} = "
        close=" }$close"
    done
    printf 'hl.config(%s{ %s = %s }%s)' \
        "$open" "${parts[n-1]}" "$(_hypr_lua_value "$value")" "$close"
}

# hypr_set <colon:path> <value>   e.g. hypr_set decoration:blur:size 5
hypr_set() {
    if hypr_uses_lua; then
        hyprctl eval "$(_hypr_lua_config_call "$1" "$2")"
    else
        hyprctl keyword "$1" "$2"
    fi
}

# hypr_bind <legacy-spec> <lua-expr>
#   hypr_bind 'SUPER,J,cyclenext' 'hl.bind("SUPER + J", hl.dsp.window.cycle_next())'
hypr_bind() {
    if hypr_uses_lua; then hyprctl eval "$2"; else hyprctl keyword bind "$1"; fi
}

# hypr_unbind <legacy-spec> <lua-keys>
#   hypr_unbind 'SUPER,J' 'SUPER + J'
hypr_unbind() {
    if hypr_uses_lua; then
        hyprctl eval "hl.unbind(\"$2\")"
    else
        hyprctl keyword unbind "$1"
    fi
}

# hypr_device_enabled <device-name> <true|false>
hypr_device_enabled() {
    if hypr_uses_lua; then
        hyprctl eval "hl.device({ name = \"$1\", enabled = $2 })"
    else
        hyprctl keyword "device:$1:enabled" "$2" -r
    fi
}

# hypr_window_rule <legacy-rule-string> <lua-expr>
hypr_window_rule() {
    if hypr_uses_lua; then hyprctl eval "$2"; else hyprctl keyword windowrule "$1"; fi
}
