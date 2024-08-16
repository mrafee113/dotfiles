#!/bin/sh

icon_null=""
icon_running=""
icon_break="󰂠"
icon_short_break="󰪓"
icon_pause="󱖐"

format_time() {
	raw="$1"
	raw="$(echo "$raw" | awk '{print int($1+0.5)}')"

	minutes="$((raw / 60))"
	minutes="$(echo "$minutes" | awk '{print int($1)}')"
	minutes="$(printf "%02d" "$minutes")"

	seconds="$((raw % 60))"
	seconds="$(echo "$seconds" | awk '{print int($1)}')"
	seconds="$(printf "%02d" "$seconds")"

	echo "${minutes}:${seconds}"
}

if ! pgrep -o gnome-pomodoro 2>&1 1>/dev/null; then
	echo "${icon_null}"
	exit 0
fi

state="$(qdbus org.gnome.Pomodoro /org/gnome/Pomodoro org.gnome.Pomodoro.State)" # pomodoro/short-break/long-break/null
if [ "$state" = null ]; then
	pkill -o gnome-pomodoro
	echo "${icon_null}"
	exit 0
fi

elapsed="$(qdbus org.gnome.Pomodoro /org/gnome/Pomodoro org.gnome.Pomodoro.Elapsed)" # 370.5015239715576
is_paused="$(qdbus org.gnome.Pomodoro /org/gnome/Pomodoro org.gnome.Pomodoro.IsPaused)" # false/true
duration="$(qdbus org.gnome.Pomodoro /org/gnome/Pomodoro org.gnome.Pomodoro.StateDuration)" # 1800
remaining="$(echo "$duration - $elapsed" | bc)"

elapsed="$(format_time "$elapsed")"
duration="$(format_time "$duration")"
remaining="$(format_time "$remaining")"

case $state in
	pomodoro)
		label="$icon_running"
		;;
	short-break)
		label="$icon_short_break"
		;;
	long-break)
		label="$icon_break"
		;;
	*)
		exit 1
		;;
esac

if [ "$is_paused" = "true" ]; then
	label="$icon_pause"
fi

label="${remaining} ${label}"
echo "$label"
exit 0
