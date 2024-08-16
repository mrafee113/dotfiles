#!/usr/bin/bash

man_list_file=/tmp/man.list

APP_NAME='man manager'
notify() { ci3-notify.sh --summary "$APP_NAME" "$@" ; }
i3exec() { ci3.sh --app-name "$APP_NAME" "$@" ; } 

gen_man_list() {
	[ -e "$man_list_file" -a ! "$1" = "-f" ] && return 0
	dir="/usr/share/man"
	dirs="$(find "$dir" -maxdepth 1 -type d ! -path "$dir" -name "man*")"
	sections="$(echo "$dirs" | xargs basename -a | sed -E 's|^man||g')"
	
	>"$man_list_file"
	while IFS= read -r -d $'\n' section; do
		find "${dir}/man${section}" -type f -name "*.gz" -printf "%f\n" |
			sed -E -e 's|\.[0-9a-zA-Z]+(\.gz)?$||g' |
			awk '{printf "%-10s ; %s\n", "'"$section"'", $1}' \
			>> "$man_list_file"
	done < <(echo "$sections")
}

select_man() {
	[ -z "$1" ] && return 0
	file="$(ci3-rofi-dmenu.sh -p "$1" -l 8 -i "$man_list_file" -w 35 -nc)"
	[ ! -n "$file" ] && notify -body 'no files were selected'
	echo "$file"
}

case "$1" in
	view)
		gen_man_list
		selected="$(select_man 'select manual')"
		[ ! -n "$selected" ] && exit 1
		sect="$(echo "$selected" | cut -d';' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		name="$(echo "$selected" | cut -d';' -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title man-modal-window -e zsh -c 'batman-s \"$sect\" \"$name\"'"
		;;
	gen-list)
		gen_man_list -f
		notify -body "generated manuals > $man_list_file"
		;;
esac
