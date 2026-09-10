#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
#  Measure idle battery draw, so the Integrated-vs-Hybrid GPU cost is a
#  number rather than a guess.
#
#  MUST run on battery — unplug first. On AC, current_now is 0 and there
#  is nothing to measure.
#
#  Run:  bash measure-battery.sh [samples]     (default 12, ~1 minute)
#
#  Compare runs across GPU modes under the SAME power profile, otherwise
#  the profile difference swamps the GPU difference.
# ══════════════════════════════════════════════════════════════════════
set -uo pipefail

SAMPLES="${1:-12}"
BAT=$(printf '%s\n' /sys/class/power_supply/BAT* | head -1)

[[ -d "$BAT" ]] || { echo "no battery found under /sys/class/power_supply"; exit 1; }

status=$(cat "$BAT/status" 2>/dev/null)
if [[ "$status" != "Discharging" ]]; then
    echo "Battery status is '$status', not 'Discharging'."
    echo "Unplug the charger and run this again — on AC there is no draw to measure."
    exit 1
fi

# Context that materially affects the reading.
printf 'GPU mode:      %s\n' "$(supergfxctl -g 2>/dev/null || echo 'n/a')"
printf 'nvidia mods:   %s\n' "$(lsmod | grep -c '^nvidia')"
printf 'power profile: %s\n' "$(powerprofilesctl get 2>/dev/null || echo 'n/a')"
printf 'governor:      %s\n' "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'n/a')"
printf 'capacity:      %s%%\n\n' "$(cat "$BAT/capacity")"

read_watts() {
    if [[ -r "$BAT/power_now" ]]; then
        awk '{printf "%.3f", $1/1000000}' "$BAT/power_now"
    elif [[ -r "$BAT/current_now" && -r "$BAT/voltage_now" ]]; then
        awk -v v="$(cat "$BAT/voltage_now")" '{printf "%.3f", ($1*v)/1e12}' "$BAT/current_now"
    else
        echo "0"
    fi
}

echo "sampling ${SAMPLES}x at 5s intervals (discard the first, it is often stale)"
vals=()
for ((i=1; i<=SAMPLES; i++)); do
    w=$(read_watts)
    vals+=("$w")
    printf '  %2d/%d  %6s W\n' "$i" "$SAMPLES" "$w"
    (( i < SAMPLES )) && sleep 5
done

printf '%s\n' "${vals[@]:1}" | awk '
    { s+=$1; n++; if(min==""||$1<min)min=$1; if($1>max)max=$1 }
    END {
        if(n==0){print "\nno samples"; exit}
        printf "\nmean %.2f W over %d samples  (min %.2f, max %.2f)\n", s/n, n, min, max
        printf "at this draw a 90Wh pack lasts about %.1f h\n", 90/(s/n)
    }'

cat <<'EOF'

Record the mean against the GPU mode above. The Integrated-vs-Hybrid
delta is the real cost of keeping the dGPU wakeable.
EOF
