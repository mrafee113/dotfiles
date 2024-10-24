#!/bin/sh

# stolen and modified from https://github.com/jbirnick/polybar-timer

APP_NAME="polybar timer"
notify() { ci3-notify.sh --summary "$APP_NAME" "$@"; }
now() { date --utc +%s; }

tdir="/tmp/_polybar-timer"

stop_timer() { rm -rf "$tdir"; }

is_timer_set() { [ -d "${tdir}" ]; }
is_timer_paused() { [ -f "$tdir/paused" ]; }

get_timer_duration() { cat "${tdir}/duration"; }
get_timer_reference() { cat "${tdir}/reference"; }
get_timer_init() { cat "${tdir}/init"; }

remove_leading_zeros() {
	num="$1"
	num="$(echo "$num" | sed -E 's|^0+||')"
	echo "${num:-0}"
}

parse_duration() {
	time="$1"
	[ -z "$time" ] && notify -body "time should not be empty" && return 1
	hours="$(echo "$time" | awk -F: '{if(NF==3) print $1; else print 0}')"
	hours="$(remove_leading_zeros "$hours")"
	minutes="$(echo "$time" | awk -F: '{if(NF==3) { print $2 } else if(NF==2) { print $1 } else { print 0 } }')"
	minutes="$(remove_leading_zeros "$minutes")"
	seconds="$(echo "$time" | awk -F: '{print $NF}')"
	seconds="$(remove_leading_zeros "$seconds")"
	if [ "$minutes" -ge 60 ] || [ "$seconds" -ge 60 ]; then notify -u critical -body "minutes and seconds should not be >= than 60" && return 1; fi
	seconds=$((seconds + minutes * 60 + hours * 60 * 60))
	echo "$seconds"
}

set_timer() {
	local duration="$1"
	[ -z "$duration" ] && notify -body "duration should not be empty" && return 1
	mkdir -p "$tdir"
	[ -n "$2" ] && echo "$(now)" >"${tdir}/init"
	echo "$(now)" >"${tdir}/reference"
	echo "$duration" >"${tdir}/duration"
}

is_timer_expired() {
	if ! is_timer_set; then return 1; fi
	[ ! -f "${tdir}/duration" ] && return 1
	[ ! -f "${tdir}/reference" ] && return 1

	duration="$(get_timer_duration)"
	reference="$(get_timer_reference)"
	rn="$(now)"
	[ "$rn" -lt "$((reference + duration))" ] && return 1
	return 0
}

get_timer_elapsed() {
	if is_timer_expired && stop_timer; then return 1; fi
	[ ! -f "${tdir}/reference" ] && return 1

	rn="$(now)"
	if [ -n "$1" ]; then
		reference="$(get_timer_init)"
	else
		reference="$(get_timer_reference)"
	fi
	echo "$((rn - reference))"
}

pause_timer() {
	elapsed="$(get_timer_elapsed)"
	duration="$(get_timer_duration)"
	duration="$((duration - elapsed))"
	echo "$duration" >"${tdir}/duration"
	echo "" >"${tdir}/paused"
	rm -f "${tdir}/reference"
}

resume_timer() {
	if ! is_timer_set; then return 1; fi
	if ! is_timer_paused; then return 1; fi

	rm -f "${tdir}/paused"
	duration="$(get_timer_duration)"
	set_timer "$duration"
}

start_timer() {
	if is_timer_set; then stop_timer; fi
	duration="$1"
	[ -z "$duration" ] && notify -body "duration should not be empty" && return 1
	duration="$(parse_duration "$duration")"
	set_timer "$duration" init
}

get_timer_remaining() {
	if ! is_timer_set; then return 1; fi
	if is_timer_paused; then
		echo "$(get_timer_duration)"
		return 0
	fi
	elapsed="$(get_timer_elapsed)"
	duration="$(get_timer_duration)"
	echo "$((duration - elapsed))"
}

format_remaining_time() {
	raw="$1"
	[ -z "$raw" ] && echo && return 0
	output=""
	hours="$(echo "$raw / 3600" | bc)"
	[ "$hours" -ge 1 ] && raw="$((raw - "$(echo "$hours * 3600" | bc)"))"
	minutes="$(echo "$raw / 60" | bc)"
	[ "$minutes" -ge 1 ] && raw="$((raw - "$(echo "$minutes * 60" | bc)"))"
	seconds="$raw"

	if [ "$hours" -gt 0 ]; then
		printf '%02d:%02d:%02d\n' "$hours" "$minutes" "$seconds"
	elif [ "$minutes" -gt 0 ]; then
		printf '%02d:%02d\n' "$minutes" "$seconds"
	else
		printf '%02d\n' "$seconds"
	fi
}

rofi_dmenu() {
	input="$(rofi -dmenu -p '[[HH:]MM:]SS' -l 0 -theme-str 'window {width: 15%; x-offset: 470; y-offset: 477;}' -theme-str 'prompt {color: #70b58a;}')"
	if ! echo "$input" | grep -Eq '^(([0-9]{1,}:)?[0-5]?[0-9]:)?[0-5]?[0-9]$'; then notify -u critical -body "format does not match regex" && exit 1; fi
	start_timer "$input"
}

format_status() {
	icon="󱦟"
	output="$icon"
	is_timer_set && output="$(format_remaining_time "$(get_timer_remaining)") ${output}"
	echo "$output"
}

case "$1" in
start)
	rofi_dmenu
	;;
stop)
	stop_timer
	;;
pause)
	pause_timer
	;;
resume)
	resume_timer
	;;
status)
	if is_timer_expired; then stop_timer; fi
	echo "$(format_status)"
	;;
start-pause-resume)
	if is_timer_set; then
		if is_timer_paused; then
			resume_timer
		else
			pause_timer
		fi
	else
		rofi_dmenu
	fi
	;;
esac
