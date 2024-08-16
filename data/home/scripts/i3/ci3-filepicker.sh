#!/usr/bin/bash


ci3-filepicker() {
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
	args[working-dir]="${args[working-dir]-${args[wd]-"${HOME}"}}"
	[ ! -d "${args[working-dir]}" ] && \
		echo "directory ${args[working-dir]} must exist" 1>&2 && \
		ci3-notify.sh --summary "${args[app-name]}" --body "directory ${args[working-dir]} must exist" && \
		exit 1
	args[file-format]="${args[file-format]-${args[f]}}"
	args[mime]="${args[mime]-${args[m]}}"

	export LF_FILEPICKER_FILE="$(mktemp)"
	echo > "$LF_FILEPICKER_FILE"
	export LF_FILEPICKER_WD="${args[working-dir]}"
	[ -n "${args[file-format]}" ] && export LF_FILEPICKER_SUFFIX="${args[file-format]}"
	[ -n "${args[mime]}" ] && export LF_FILEPICKER_MIMETYPE="${args[mime]}"

	alacritty --title lf-filepicker-modal-window -e zsh -c "lf -command ':filepicker-mode'"
	if [ ! -f "$LF_FILEPICKER_FILE" ] || [ ! -n "$(cat "$LF_FILEPICKER_FILE")" ]; then
		echo "no files were picked" 1>&2
		ci3-notify.sh --summary "${args[app-name]}" -body "no files were picked"
		exit
	fi

	sed -n '1p' "$LF_FILEPICKER_FILE"
}

if [[ "${BASH_SOURCE}" == "${0}" ]]; then
        ci3-filepicker "$@"
fi
