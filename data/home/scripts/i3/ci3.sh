#!/usr/bin/bash

ci3-socket() {
	i3pid="$(pgrep -o i3)"
	socket=
	if [[ -v I3SOCK ]] && [ -S "$I3SOCK" ]; then
		socket="$I3SOCK"
	elif [[ -v XDG_RUNTIME_DIR ]] && [ -n "$XDG_RUNTIME_DIR" -a -S "$XDG_RUNTIME_DIR/i3/ipc-socket.$i3pid" ]; then
		socket="$XDG_RUNTIME_DIR/i3/ipc-socket.$i3pid"
	fi

	if [ ! -n "$socket" ]; then
		ci3-notify.sh -u critical --summary "${1-unknown}" --body "could not find i3 socket"
		echo "could not find i3 socket" 1>&2
		exit 1
	fi

	echo "$socket"
}

ci3-exec() {
	declare -A args
	while [[ $# -gt 0 ]]; do
		key="$(echo "$1" | sed -E -e 's|^--||g' | sed -E -e 's|^-||g')"
		shift
		if [ ! -z "$1" ] && [[ ! "$1" == -* ]]; then
			value="$1"
			shift
		else
			value="true"
		fi
		args["$key"]="$value"
	done
	
	args[cmd]="${args[cmd]-${args[c]}}"
	[ ! -n "${args[cmd]}" ] && echo "no command provided" 1>&2 && exit 1
	args[app-name]="${args[app-name]-${args[a]-unknown}}"

	socket="$(ci3-socket "${args[app-name]}")"
	[ ! -n "$socket" ] && exit 1
	i3-msg -s "$socket" "${args[cmd]}" 1>/dev/null
}

if [[ "${BASH_SOURCE}" == "${0}" ]]; then
	ci3-exec "$@"
fi
