#!/usr/bin/bash

ci3-notify() {
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

	args[urgency]="${args[urgency]-${args[u]-low}}"
	[[ ! "${args[urgency]}" =~ ^(low|normal|critical)$ ]] && echo "invalid urgency ${args[urgency]}" 1>&2 && exit 1
	args[icon]="${args[icon]-${args[i]}}"
	[ -n "${args[icon]}" -a ! -f "${args[icon]}" ] && echo "invalid icon ${args[icon]}" 1>&2 && exit 1
	args[expire-time]="${args[expire-time]-${args[et]-4000}}"
	[[ ! "${args[expire-time]}" =~ ^[0-9]+$ ]] && echo "invalid expire-time ${args[expire-time]}" 1>&2 && exit 1
	args[summary]="${args[summary]-${args[s]}}"
	[ ! -n "${args[summary]}" ] && echo "invalid summary ${args[summary]}" 1>&2 && exit 1
	echo "${args[summary]}" | grep '"' 2>&1 1>/dev/null
	[ $? -eq 0 ] && echo "invalid summary ${args[summary]}" 1>&2 && exit 1
	args[body]="${args[body]-${args[b]}}"
	[ ! -n "${args[body]}" ] && echo "invalid body ${args[body]}" 1>&2 && exit 1
	echo "${args[body]}" | grep \" 2>&1 1>/dev/null
	[ $? -eq 0 ] && echo "invalid body ${args[body]}" 1>&2 && exit 1

	cmd="notify-send"
	cmd+=" -u ${args[urgency]}"
	cmd+=" -t ${args[expire-time]}"
	[ -n "${args[icon]}" ] && cmd+=" -i ${args[icon]}"
	cmd+=" \"${args[summary]}\" \"${args[body]}\""

	eval "$cmd"
}

if [[ "${BASH_SOURCE}" == "${0}" ]]; then
        ci3-notify "$@"
fi
