#!/usr/bin/bash

cfd="$(realpath "$(dirname "${BASH_SOURCE}")")"
color_alert="$($cfd/../color.sh alert)"
color_primary="$($cfd/../color.sh primary)"
color_info="$($cfd/../color.sh info)"

icon_mute=󰝟
icon_zero=󰝞
icon_low=󰕿
icon_medium=󰖀
icon_high=󰕾
icon_alert=󱄡

status="$(pulseaudio-ctl full-status)"
level="$(echo "$status" | cut -d' ' -f1)"
muted="$(echo "$status" | cut -d' ' -f2)"

icon=
icon_color="$color_primary"
if [ "$muted" = yes ]; then
	icon=$icon_mute
	icon_color="$color_info"
elif [ "$level" -eq 0 ]; then
	icon=$icon_zero
elif [ "$level" -gt 0 -a "$level" -le 33 ]; then
	icon=$icon_low
elif [ "$level" -gt 33 -a "$level" -le 66 ]; then
	icon=$icon_medium
elif [ "$level" -gt 66 -a "$level" -le 100 ]; then
	icon=$icon_high
else
	icon=$icon_alert
	icon_color="$color_alert"
fi

icon="%{F$icon_color}${icon}%{F-}"
icon="%{T3}${icon}%{T-}"

sep=
if [ "$level" -lt 10 ]; then
	sep="  "
elif [ "$level" -ge 10 -a "$level" -lt 100 ]; then
	sep=" "
fi
level="${level}%${sep}"
level="%{F$icon_color}${level}%{F-}"
level="%{T1}${level}%{T-}"

echo "${icon} ${level}"
