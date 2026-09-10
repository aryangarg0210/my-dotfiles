#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
# Hyprland parser compatibility (legacy .conf vs lua) - see hypr-compat.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hypr-compat.sh"



HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    # (was a single `hyprctl --batch`; batching mixes parsers badly, so these
    #  go through the compat helper one at a time)
    hypr_set animations:enabled 0
    hypr_set decoration:shadow:enabled 0
    hypr_set decoration:blur:enabled 0
    hypr_set general:gaps_in 0
    hypr_set general:gaps_out 0
    hypr_set general:border_size 1
    hypr_set decoration:rounding 0
	
	hypr_window_rule "opacity 1 override 1 override 1 override, match:class ^(.*)$" \
		'hl.window_rule({ match = { class = "^(.*)$" }, opacity = "1 override 1 override 1 override" })'
    awww kill 
    notify-send -e -u low -i "$notif" " Gamemode:" " enabled"
    sleep 0.1
    exit
else
	awww-daemon --format xrgb && awww img "$HOME/.config/rofi/.current_wallpaper" &
	sleep 0.1
	${SCRIPTSDIR}/WallustSwww.sh
	sleep 0.5
  hyprctl reload
	${SCRIPTSDIR}/Refresh.sh	 
    notify-send -e -u normal -i "$notif" " Gamemode:" " disabled"
    exit
fi
hyprctl reload
