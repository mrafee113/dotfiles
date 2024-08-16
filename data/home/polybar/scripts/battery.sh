#!/bin/sh

cfd="$(realpath "$(dirname "${BASH_SOURCE}")")"
color_alert="$($cfd/../color.sh alert)"
color_primary="$($cfd/../color.sh primary)"
color_info="$($cfd/../color.sh info)"

FULL_AT=65
LOW_AT=35
PATH_AC="/sys/class/power_supply/AC0"
PATH_BATTERY="/sys/class/power_supply/BAT0"

ac=0
battery_level=0
battery_max=0

if [ -f "$PATH_AC/online" ]; then
    ac=$(cat "$PATH_AC/online")
fi

if [ -f "$PATH_BATTERY/energy_now" ]; then
    battery_level=$(cat "$PATH_BATTERY/energy_now")
fi

if [ -f "$PATH_BATTERY/energy_full" ]; then
    battery_max=$(cat "$PATH_BATTERY/energy_full")
fi

battery_percent=$(("$battery_level * 100"))
battery_percent=$(("$battery_percent / $battery_max"))

if [ "$ac" -eq 1 ]; then
	label_prefix=+
else
	label_prefix=-
fi

label="${battery_percent}%"
if [ "$battery_percent" -ge "$FULL_AT" ] || [ "$battery_percent" -le "$LOW_AT" ]; then
	label="%{F$color_alert}${label_prefix}${label}%{F-}"
else
	label="%{F$color_info}${label_prefix}${label}%{F-}"
fi
label="%{T1}${label}%{T-}"

if [ "$battery_percent" -ge 100 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰂅; else icon=󰁹; fi
elif [ "$battery_percent" -ge 90 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰂋; else icon=󰂂; fi
elif [ "$battery_percent" -ge 80 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰂊; else icon=󰂁; fi
elif [ "$battery_percent" -ge 70 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰢞; else icon=󰂀; fi
elif [ "$battery_percent" -ge 60 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰂉; else icon=󰁿; fi
elif [ "$battery_percent" -ge 50 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰢝; else icon=󰁾; fi
elif [ "$battery_percent" -ge 40 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰂈; else icon=󰁽; fi
elif [ "$battery_percent" -ge 30 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰂇; else icon=󰁼; fi
elif [ "$battery_percent" -ge 20 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰂆; else icon=󰁻; fi
elif [ "$battery_percent" -ge 10 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰢜; else icon=󰁺; fi
elif [ "$battery_percent" -ge 0 ]; then
	if [ "$ac" -eq 1 ]; then icon=󰢜; else icon=󰂎; fi
fi

icon="%{F$color_primary}${icon}%{F-}"

# this part was moved to cron
# notify() {
# 	file=/tmp/battery-notify-sent
# 	if [ -f $file ] && [ "$(stat -c '%Y' $file)" -ge "$(date -d '-5 mins' +%s)" ]; then return 0; fi
# 	notify-send --urgency=critical --expire-time=15000 --icon=/usr/share/icons/Adwaita/symbolic/status/battery-caution-symbolic.svg battery "at $battery_percent"
# 	touch $file
# }
# if ([ "$ac" -eq 1 ] && [ "$battery_percent" -eq "$FULL_AT" ]) || ([ "$ac" -eq 0 ] && [ "$battery_percent" -eq "$LOW_AT" ]); then notify; fi

echo "${icon} ${label}"
