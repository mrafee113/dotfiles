#!/usr/bin/bash

ci3-input-text() {
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

	args[app-name]="${args[app-name]-${args[a]-unknown}}"
	args[notification-text]="${args[notification-text]-${args[nt]-"text shouldn't be empty"}}"

	args[prompt]="${args[prompt]-${args[p]}}"
	[ ! -n "${args[prompt]}" ] && echo "invalid prompt ${args[prompt]}" 1>&2 && exit 1
	args[width]="${args[width]-${args[w]}}"
	[[ ! -n "${args[width]}" || ! "${args[width]}" =~ ^[0-9]+$ ]] && echo "invalid width ${args[width]}" 1>&2 && exit 1
	args[message]="${args[message]-${args[m]}}"

	cmd="ci3-rofi-dmenu.sh -l 0 -entry"
	cmd+=" -p \"${args[prompt]}\""
	cmd+=" -w ${args[width]}"
	[ -n "${args[message]}" ] && cmd+=" -m \"${args[message]}\""

	txt="$(eval "$cmd")"
	[ ! -n "$txt" ] && ci3-notify.sh --summary "${args[app-name]}" --body "${args[notification-text]}" && echo "${args[nt]}" 1>&2 && exit 1

	echo "$txt"
}

ci3-input-filepath() {
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

	args[relative]="${args[relative]-${args[r]-false}}"
	args[app-name]="${args[app-name]-${args[a]-unknown}}"
	args[prefix-dir]="${args[prefix-dir]-${pd}}"
	[[ -n "${args[prefix-dir]}" && ! -d "${args[prefix-dir]}" ]] && \
		ci3-notify.sh -u critical --summary "${args[app-name]}" -body "prefix directory ${args[prefix-dir]} does not exist" && \
		echo "prefix directory ${args[prefix-dir]} does not exist" 1>&2 && \
		exit 1

	args[prompt]="${args[prompt]-${args[p]}}"
	[ ! -n "${args[prompt]}" ] && echo "invalid prompt ${args[prompt]}" 1>&2 && exit 1
	args[message]="${args[message]-${args[m]}}"
	
	cmd="ci3-input.sh txt -w 25"
	cmd+=" --app-name ${args[app-name]}"
	cmd+=" -nt 'filepath should not be empty'"
	cmd+=" -p \"${args[prompt]}\""
	[ -n "${args[message]}" ] && cmd+=" -m \"${args[message]}\""

	filepath="$(eval "$cmd")"
	[ ! -n "$filepath" ] && echo "empty filepath" 1>&2 && exit 1
	[ "${args[relative]}" = false -a ! -f "${args[prefix-dir]}/$file" ] && \
		ci3-notify.sh -u critical --summary "${args[app-name]}" -body "directory ${args[prefix-dir]} doesn't exist" && \
		echo "directory ${args[prefix-dir]} doesn't exist" 1>&2 && \
		exit 1
	echo "$filepath"
}

ci3-input-num() {
	num="$(ci3-input.sh txt "$@")"
	[ ! -n "$num" ] && echo "empty output" 1>&2 && exit 1

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
	
	args[app-name]="${args[app-name]-${args[a]-unknown}}"

	[[ ! "$num" =~ ^[0-9]+$ ]] && ci3-notify.sh --summary "${args[app-name]}" --body "value $num must be a number" && echo "value $num must be a number" 1>&2 && exit 1
	echo "$num"
}

if [[ "${BASH_SOURCE}" == "${0}" && -n "$1" ]]; then
	cmd="$1"; shift
	case "$cmd" in
		txt|text) ci3-input-text "$@" ;;
		file|filepath|path) ci3-input-filepath "$@" ;;
		num|number) ci3-input-num "$@" ;;
	esac
fi
