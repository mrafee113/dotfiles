#!/usr/bin/env bash

CONKY_DIR="${HOME}/.config/conky"

fetch() {
	find "$CONKY_DIR"/ -type f -name "*.rc" -print0
}

quit() {
	pkill -f "conky -c ${CONKY_DIR}/$1"
}

setup() {
	[ "$2" = true ] && quit "$1"
	if ! pgrep -f "conky -c $HOME/.config/conky/$1" 1>/dev/null 2>&1; then
		ci3.sh --cmd "exec --no-startup-id \"conky -c '${CONKY_DIR}/$1' 1>>'/var/log/francis/conky-${1%.rc}.log' 2>>'/var/log/francis/conky-${1%.rc}.errlog' & disown\""
	fi
}

force=false
to_quit=false
while [[ $# -gt 0 ]]; do
	arg="$1"
	shift
	case "$arg" in
	-q) to_quit=true ;;
	-f) force=true ;;
	*) conf="$arg" ;;
	esac
done

if [ "$to_quit" = true ]; then
	if [ -n "$conf" ]; then
		quit "$conf"
	else
		while IFS= read -r -d '' file; do
			file="$(basename "$file")"
			quit "$file"
		done < <(fetch)
	fi
	exit 0
fi

if [ -n "$conf" ] && [ "$force" = true ]; then
	setup "$conf" true
elif [ -n "$conf" ]; then
	setup "$conf" false
else
	while IFS= read -r -d '' file; do
		file="$(basename "$file")"
		setup "$file" "$force"
	done < <(fetch)
fi
