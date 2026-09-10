#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly

notif="$HOME/.config/swaync/images/ja.png"
# Hyprland parser compatibility (legacy .conf vs lua) - see hypr-compat.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hypr-compat.sh"


LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

# Reverse layout value to reuse toggle logic. So layouts don't get swapped initially.
if [ "$1" = "init" ]; then
  if [ "$LAYOUT" = "master" ]; then
    LAYOUT="dwindle"
  else
    LAYOUT="master"
  fi
fi

case $LAYOUT in
"master")
  hypr_set general:layout dwindle
  hypr_unbind "SUPER,J" "SUPER + J"
  hypr_unbind "SUPER,K" "SUPER + K"
  hypr_bind "SUPER,J,cyclenext" 'hl.bind("SUPER + J", hl.dsp.window.cycle_next())'
  hypr_bind "SUPER,K,cyclenext,prev" 'hl.bind("SUPER + K", hl.dsp.window.cycle_next({ next = false }))'
  hypr_bind "SUPER,O,layoutmsg,togglesplit" 'hl.bind("SUPER + O", hl.dsp.layout("togglesplit"))'
  notify-send -e -u low -i "$notif" " Dwindle Layout"
  ;;
"dwindle")
  hypr_set general:layout master
  hypr_unbind "SUPER,J" "SUPER + J"
  hypr_unbind "SUPER,K" "SUPER + K"
  hypr_unbind "SUPER,O" "SUPER + O"
  hypr_bind "SUPER,J,layoutmsg,cyclenext" 'hl.bind("SUPER + J", hl.dsp.layout("cyclenext"))'
  hypr_bind "SUPER,K,layoutmsg,cycleprev" 'hl.bind("SUPER + K", hl.dsp.layout("cycleprev"))'
  notify-send -e -u low -i "$notif" " Master Layout"
  ;;
*) ;;

esac
