#!/usr/bin/bash

APP_NAME='cheat manager'

notify() { ci3-notify.sh --summary "$APP_NAME" "$@" ; }
input_text() { ci3-input.sh txt --app-name "$APP_NAME" "$@" ; }
i3exec() { ci3.sh --app-name "$APP_NAME" "$@" ; } 

gen_cheats() {
	[ ! "$1" = -f ] && [[ -f /tmp/cheat-files && -z "$(find "${HOME}/.config/cheat/cheatsheets" -type f -newer /tmp/cheat-files ! -path "*/.git/*" ! -path "*/.github/*")" ]] && return 0
	find "${HOME}/.config/cheat/cheatsheets" -type f ! -path "*/.git/*" ! -path "*/.github/*" |
		sed -E 's|.*cheat/cheatsheets/||g' |
		awk '{split($1, a, "/"); b = a[2]; for (i=3;i<=length(a);i++) b = b "/" a[i]; printf "%-50s ; %s\n", b, a[1]}' > /tmp/cheat-files
}

select_cheat() {
	[ -z "$2" ] && return 0
	gen_cheats
	if [ "$3" = -w ]; then
		grep -vE '; community$' /tmp/cheat-files > /tmp/cheat-files-w
		file="$(ci3-rofi-dmenu.sh -p "$1" -msg "$2" -l 8 -i /tmp/cheat-files-w -w 50 -nc)"
	else
		file="$(ci3-rofi-dmenu.sh -p "$1" -msg "$2" -l 8 -i /tmp/cheat-files -w 50 -nc)"
	fi
	[ ! -n "$file" ] && notify -body "no file was selected" && return 0
	echo "$file"
}

select_path() {
	[ -z "$1" ] && return 0
	find "${HOME}/.config/cheat/cheatsheets" -maxdepth 1 -type d ! -path "${HOME}/.config/cheat/cheatsheets" ! -name "community" |
		awk '{split($1, a, "/"); print a[length(a)]}' \
		> /tmp/cheat-paths
	if [ ! "$2" = "-f" -a "$(wc -l /tmp/cheat-paths | cut -d' ' -f1)" -eq 1 ]; then
		file="$(cat /tmp/cheat-paths)"
	else
		file="$(ci3-rofi-dmenu.sh -p 'select path' -msg "$1" -l 4 -i /tmp/cheat-paths -w 30 -nc)"
	fi
	[ ! -n "$file" ] && notify -body 'no path was selected' && return 0
	echo "$file"
}

case "$1" in
	view)
		selected="$(select_cheat 'cheat file' 'to view')"
		[ ! -n "$selected" ] && exit 1
		name="$(echo "$selected" | cut -d';' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		path="$(echo "$selected" | cut -d';' -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title cheat-modal-window -e zsh -c 'cheat -p \"$path\" \"$name\" | bat --wrap never --paging always --pager \"less -R\" --tabs 4 --file-name \"$name\" -l bash'"
		;;
	edit)
		selected="$(select_cheat 'cheat file' 'to edit')"
		[ ! -n "$selected" ] && exit 1
		name="$(echo "$selected" | cut -d';' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		path="$(echo "$selected" | cut -d';' -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		if [ "$path" = "community" ]; then
			path=""
		else
			path="-p \"$path\""
		fi
		i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title cheat-modal-window -e zsh -c 'cheat $path -e \"$name\"'"
		;;
	create)
		path="$(select_path 'to create cheat')"
		[ ! -n "$path" ] && exit 1
		name="$(input_text -p 'cheat name' -w 35)"
		[ ! -n "$name" ] && exit 1
		i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title cheat-modal-window -e zsh -c 'cheat -p \"$path\" -e \"$name\"'"
		gen_cheats -f
		;;
	delete)
		gen_cheats -f 
		if [ ! -f /tmp/cheat-files ] || ! grep -vE '; community$' /tmp/cheat-files 2>&1 1>/dev/null; then
			notify -body 'there are no files to delete'
			exit 0
		fi
		selected="$(select_cheat 'cheat file' 'to delete' -w)"
		[ ! -n "$selected" ] && exit 1
		name="$(echo "$selected" | cut -d';' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		path="$(echo "$selected" | cut -d';' -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title cheat-modal-window -e zsh -c 'cheat -p \"$path\" --rm=\"$name\"'"
		gen_cheats -f
		;;
	create-path)
	 	path="$(input_text -p 'path name' -w 35)"
		if ls -1 "${HOME}/.config/cheat/cheatsheets" | grep -E '^'"$path"'$' 2>&1 1>/dev/null ||
		   grep -E "^[[:space:]]*- name: $path" "${HOME}/.config/cheat/conf.yml" 2>&1 1>/dev/null; then
			notify -u critical -body 'path already exists'
			exit 0
		fi
		mkdir "${HOME}/.config/cheat/cheatsheets/$path"
		yq -i ".cheatpaths += [{\"name\": \"$path\", \"path\": \"${HOME}/.config/cheat/cheatsheets/$path\", \"tags\": [\"$path\"], \"readonly\": false}]" "${HOME}/.config/cheat/conf.yml"
		;;
	remove-path)
		path="$(select_path 'path name' -f)"
		[ ! -n "$path" ] && notify -body 'path must not be empty' && exit 1
		ls -1 "${HOME}/.config/cheat/cheatsheets" | grep -E '^'"$path"'$' 2>&1 1>/dev/null
		dir_exists=$?
		test -n "$(yq ".cheatpaths[] | select(.name == \"$path\")" "${HOME}/.config/cheat/conf.yml")"
		conf_exists=$?
		if [ $dir_exists -ne 0 ]; then
			notify -u critical -body 'path does not exist'
		else
			rm -r --interactive=never "${HOME}/.config/cheat/cheatsheets/$path"
		fi
		if [ $conf_exists -ne 0 ]; then
			notify -u critical -body 'conf does not exist'
		else
			yq -i "del(.cheatpaths[] | select(.name == \"$path\"))" "${HOME}/.config/cheat/conf.yml"
		fi
		;;
esac
