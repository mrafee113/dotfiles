#!/usr/bin/bash

CONKY_LAUNCHER="${HOME}/.config/conky/launch.sh"
POLYBAR_LAUNCHER="${HOME}/.config/polybar/launch.sh"
i3exec() { ci3.sh --cmd "exec --no-startup-id $@" ; }

ci3-restarter() {
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
	
	args[app]="${args[app]-${args[e]-all}}"
	[[ ! "${args[app]}" =~ ^(conky|picom|polybar|dunst|hiddify|nekoray|all)$ ]] && echo "invalid app ${args[app]}" 1>&2 && exit 1
	args[cmd]="${args[cmd]-${args[c]-restart}}"
	[[ ! "${args[cmd]}" =~ ^(restart|quit)$ ]] && echo "invalid cmd ${args[cmd]}" 1>&2 && exit 1
	
	case "${args[app]}" in
		conky)
			case "${args[cmd]}" in
				restart) i3exec "$CONKY_LAUNCHER -f" ;;
				quit)    i3exec "$CONKY_LAUNCHER -q" ;;
			esac
			;;
		picom)
			case "${args[cmd]}" in
				restart) i3exec "pkill picom"; i3exec "picom -b" ;;
				quit)    i3exec "pkill picom" ;;
			esac
			;;
		polybar)
			case "${args[cmd]}" in
				restart) i3exec "$POLYBAR_LAUNCHER" ;;
				quit)    i3exec "$POLYBAR_LAUNCHER -q" ;;
			esac
			;;
		dunst) i3exec "pkill dunst"; i3exec "notify-send 'restart dunst'" ;;
		hiddify)
			case "${args[cmd]}" in
				restart) i3exec "pkill hiddify"; i3exec "hiddify" ;;
				quit)    i3exec "pkill hiddify" ;;
			esac
			;;
		nekoray) 
			case "${args[cmd]}" in
				restart) i3exec "pkill nekoray"; i3exec "nekoray" ;;
				quit)    i3exec "pkill nekoray" ;;
			esac
			;;
		all)
			for app in conky picom polybar dunst hiddify nekoray ; do
				ci3-restarter --app "$app" --cmd "${args[cmd]}"
			done
			;;
		*) exit 1;;
	esac
}

if [[ "${BASH_SOURCE}" == "${0}" ]]; then
	ci3-restarter "$@"
fi
