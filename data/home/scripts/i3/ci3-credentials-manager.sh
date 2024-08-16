#!/usr/bin/bash

APP_NAME='credentials manager'
notify() { ci3-notify.sh --summary "$APP_NAME" "$@" ; }
input_text() { ci3-input.sh txt --app-name "$APP_NAME" "$@" ; } 
i3exec() { ci3.sh --app-name "$APP_NAME" "$@" ; } 
pick_file() { ci3-filepicker.sh --app-name "$APP_NAME" "$@" -wd "$CREDENTIALS_DIR" -f '.enc' ; }

determine_lang() {
	[ -z "$1" -o ! -f "$1" ] && echo "yaml" && return 0
	filename="$(basename "$1")"
	[[ "$filename" = *.enc ]] && filename="${filename%.enc}"
	[[ ! "$filename" = *.* ]] && echo "yaml" && return 0
	filename="${filename##*.}"
	[ -z "$filename" ] && echo "yaml" && return 0
	if bat --list-languages | grep "[,:]$filename(,|$)" 2>&1 1>/dev/null; then
		echo "$filename"
		return 0
	fi
	echo "yaml"
}

case "$1" in
	view)
		file="$(pick_file)"
		[ ! -n "$file" ] && exit 0
		filename="${file##$CREDENTIALS_DIR}"
		lang="$(determine_lang "$file")"
		if [[ "$filename" = *.enc ]]; then
			i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title credentials-modal-window -e zsh -i -c 'view-cred \"$file\" | bat --wrap never --paging always --pager \"less -R\" --tabs 4 --file-name \"$filename\" -l $lang'"
		else
			i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title credentials-modal-window -e zsh -i -c 'bat --wrap never --paging always --pager \"less -R\" --tabs 4 --file-name \"$filename\" -l $lang \"$file\"'"
		fi
		;;
	create)
		filepath="$(input_text -p 'file path' -m 'enter the path relative to the creds directory' -w 60)"
		[ ! -n "$filepath" ] && exit 1
		echo "${filepath}"
		[[ "$filepath" =~ ^/ ]] && notify -body 'the path should not start with /' && exit 1
		file="${CREDENTIALS_DIR}/${filepath}"
		[ -f "$file" ] && notify -u critical -body 'file already exists' && exit 1
		dir="$(dirname "$file")"
		[ ! -d "$dir" ] && mkdir -p "$dir"
		i3exec --cmd "exec --no-startup-id \"i3-sensible-terminal --title credentials-edit-modal-window -e zsh -i -c 'vim \\\"${file}\\\" && if [ -f \\\"$file\\\" ]; then log_info encrypting \\\"$file\\\"; encfile \\\"$file\\\" ; fi'\""
		;;
	delete)
		file="$(pick_file)"
		[ ! -n "$file" ] && exit 0
		[ -f "$file" -a -w "$file" ] && rm -f "$file"
		;;
	modify)
		file="$(pick_file)"
		[ ! -n "$file" ] && exit 0
		i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title credentials-edit-modal-window -e zsh -i -c 'mod-cred \"${file}\"'"
		;;
esac
