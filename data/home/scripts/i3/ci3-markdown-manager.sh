#!/usr/bin/bash

APP_NAME='markdown manager'
notify() { ci3-notify.sh --summary "$APP_NAME" "$@" ; }
i3exec() { ci3.sh --app-name "$APP_NAME" "$@" ; } 
pick_file() { ci3-filepicker.sh --app-name "$APP_NAME" -wd "$THINKTANK_DIR" "$@" ; }

case "$1" in
	view)
		file="$(pick_file -f '.md')"
		[ ! -n "$file" ] && exit 1
		i3exec --cmd "exec --no-startup-id i3-sensible-terminal --title markdown-modal-window -e zsh -c 'glow -p \"$file\"'"
		;;
esac
