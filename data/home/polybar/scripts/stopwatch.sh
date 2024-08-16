#!/bin/sh

# stolen and modified from https://github.com/jbirnick/polybar-timer

now () { date --utc +%s; }

tdir="/tmp/_polybar-stopwatch"

stop_timer () { rm -rf "$tdir" ; }

is_timer_set () { [ -d "${tdir}" ] ; }
is_timer_paused () { [ -f "${tdir}/paused" ] ; }

get_timer_reference() { cat "${tdir}/reference" ; }
get_timer_elapsed() { cat "${tdir}/elapsed" ; }

set_timer() {
	if is_timer_set && ! is_timer_paused; then return 1; fi
	mkdir -p "$tdir"
	[ ! -f "${tdir}/elapsed" ] && echo "0" > "${tdir}/elapsed"
	echo "$(now)" > "${tdir}/reference"
}

eval_timer_elapsed() {
	[ ! -f "${tdir}/reference" ] && echo 0 && return 0

	rn="$(now)"
	reference="$(get_timer_reference)"
	echo "$((rn - reference))"
}

pause_timer() {
	echo "$(("$(get_timer_elapsed)" + "$(eval_timer_elapsed)"))" > "${tdir}/elapsed"
	echo "" > "${tdir}/paused"
	rm -f "${tdir}/reference"
}

resume_timer() {
	if ! is_timer_set;    then return 1; fi
	if ! is_timer_paused; then return 1; fi
	
	set_timer
	rm -f "${tdir}/paused"
}

get_total_elapsed_time() {
	echo "$(("$(get_timer_elapsed)" + "$(eval_timer_elapsed)"))"
}

format_elapsed_time() {
	raw="$1"
	[ -z "$raw" ] && echo && return 0
	output=""
	hours="$(echo "$raw / 3600" | bc)"
	[ "$hours"   -ge 1 ] && raw="$((raw - "$(echo "$hours * 3600" | bc)"))"
	minutes="$(echo "$raw / 60" | bc)"
	[ "$minutes" -ge 1 ] && raw="$((raw - "$(echo "$minutes * 60" | bc)"))"
	seconds="$raw"
	
	printf '%02d:%02d:%02d\n' "$hours" "$minutes" "$seconds"
	return 0
	if   [ "$hours"   -gt 0 ]; then
		printf '%02d:%02d:%02d\n' "$hours" "$minutes" "$seconds"
	elif [ "$minutes" -gt 0 ]; then
		printf '%02d:%02d\n' "$minutes" "$seconds"
	else
		printf '%02d\n' "$seconds"
	fi
}

format_status() {
	icon="󱎫"
	output="$icon"
	is_timer_set && output="$(format_elapsed_time "$(get_total_elapsed_time)") ${output}"
	echo "$output"
}

case "$1" in 
	start)
		set_timer
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
			set_timer
		fi
		;;
esac
