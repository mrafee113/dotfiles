#!/usr/bin/bash

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

if [ "$ac" -eq 1 -a "$battery_percent" -eq "$((FULL_AT - 1))" ] || [ "$ac" -eq 0 -a "$battery_percent" -eq "$((LOW_AT + 1))" ]; then
	socket="/run/user/1000/i3/ipc-socket.$(pgrep -o i3)"
	socket="$(find "$socket" -type s 2>/dev/null)"
	[ ! -n "$socket" ] && exit 1
	file=/tmp/battery-notify-sent
	if [ -f $file ] && [ "$(stat -c '%Y' $file)" -ge "$(date -d '-5 mins' +%s)" ]; then exit 0; fi
	i3-msg -s "$socket" "exec --no-startup-id dunstify --urgency=critical --timeout=15000 --icon=/usr/share/icons/Adwaita/symbolic/status/battery-caution-symbolic.svg battery \"at $battery_percent\"" 1>/dev/null 2>&1
	touch $file
fi
