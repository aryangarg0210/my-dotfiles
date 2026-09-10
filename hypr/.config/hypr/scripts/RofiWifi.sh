#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# WiFi picker — scan, list, and connect using rofi + nmcli

notif="$HOME/.config/swaync/images/ja.png"

# Trigger a background rescan (non-blocking)
nmcli device wifi rescan 2>/dev/null &

# Build network list: SSID | signal bars | security
wifi_list=$(nmcli -f IN-USE,SSID,BARS,SECURITY device wifi list 2>/dev/null \
    | tail -n +2 \
    | awk '{ in_use=$1; $1=""; line=$0; gsub(/^[ \t]+/,"",line); print (in_use=="*" ? "󰤨 " : "  ") line }' \
    | sed '/^[[:space:]]*$/d')

[ -z "$wifi_list" ] && {
    notify-send -u low -i "$notif" "WiFi" "No networks found"
    exit 1
}

chosen=$(echo "$wifi_list" | rofi -dmenu -p "  WiFi" -i -no-custom -format s)

[ -z "$chosen" ] && exit 0

# Strip leading status icon and extract SSID (first word after icon+space)
ssid=$(echo "$chosen" | sed 's/^[^ ]* //' | awk '{print $1}')

[ -z "$ssid" ] && exit 0

# If already connected, offer to disconnect
if nmcli -t -f ACTIVE,SSID dev wifi | grep -q "^yes:$ssid$"; then
    action=$(printf "Stay connected\nDisconnect" | rofi -dmenu -p "  $ssid" -i -no-custom -format s)
    [[ "$action" == "Disconnect" ]] && nmcli connection down "$ssid" 2>/dev/null \
        && notify-send -u low -i "$notif" "WiFi" "Disconnected from $ssid"
    exit 0
fi

# Use existing saved profile if available
if nmcli connection show "$ssid" &>/dev/null; then
    nmcli connection up "$ssid" && \
        notify-send -u low -i "$notif" "WiFi" "Connected to $ssid" || \
        notify-send -u critical -i "$notif" "WiFi" "Failed to connect to $ssid"
    exit $?
fi

# New network — check if password is needed
security=$(echo "$chosen" | awk '{print $NF}')
if [[ "$security" != "--" && -n "$security" ]]; then
    password=$(rofi -dmenu -p "  Password for $ssid" -password -no-custom -l 0)
    [ -z "$password" ] && exit 0
    nmcli device wifi connect "$ssid" password "$password" && \
        notify-send -u low -i "$notif" "WiFi" "Connected to $ssid" || \
        notify-send -u critical -i "$notif" "WiFi" "Failed — wrong password?"
else
    nmcli device wifi connect "$ssid" && \
        notify-send -u low -i "$notif" "WiFi" "Connected to $ssid" || \
        notify-send -u critical -i "$notif" "WiFi" "Failed to connect to $ssid"
fi
