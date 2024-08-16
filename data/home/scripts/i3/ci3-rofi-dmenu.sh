#!/usr/bin/bash

# -C/--color    [str]=#70b58a -- color of the menu
# -M/--matching [str]=normal  -- sets matching algorithm ; normal, regex, glob, fuzzy, prefix
# -w/--width    [int]=20      -- percent of screen width
# -l/--lines    [int]=0       -- number of lines to show
# -p/--prompt   [str]         -- prompt to show in menu (left to text bar)
# -m/--msg      [str]         -- (mini) message to show for extra info (below text bar)
# -c/--content  [str]         -- sets the default text in menu inputbar ; recommended use with --entry
# -i/--input   [file]         -- the file to read input from
# -e/--entry 			      -- changes menu (theme) to solely be a text inputbar
# -nc/--no-custom	          -- do not enter custom arguments

ci3-rofi-dmenu() {
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

	# defaults
	args[color]=${args[color]-${args[C]-"#70b58a"}}
	[[ ! "${args[color]}" =~ ^#[a-zA-Z0-9]{6,8}$ ]] && echo "invalid color ${args[color]}" 1>&2 && exit 1
	args[matching]=${args[matching]-${args[M]-normal}}
	[[ ! "${args[matching]}" =~ ^(normal|regex|glob|fuzzy|prefix)$ ]] && echo "invalid matching ${args[matching]}" 1>&2 && exit 1
	args[width]=${args[width]-${args[w]-20}}
	[[ ! "${args[width]}" =~ ^[0-9]+$ ]] && echo "invalid width ${args[widht]}" 1>&2 && exit 1
	args[lines]=${args[lines]-${args[l]-0}}	
	[[ ! "${args[lines]}" =~ ^[0-9]+$ ]] && echo "invalid lines ${args[lines]}" 1>&2 && exit 1
	args[prompt]=${args[prompt]-${args[p]}}
	[ ! -n "${args[prompt]}" ] && echo "invalid prompt ${args[prompt]}" 1>&2 && exit 1
	args[msg]=${args[msg]-${args[m]}}
	args[content]=${args[content]-${args[c]}}
	args[input]=${args[input]-${args[i]}}
	[ -n "${args[input]}" -a ! -f "${args[input]}" ] && echo "invalid input ${args[input]}" 1>&2 && exit 1
	args[entry]=${args[entry]-${args[e]}}
	[ -n "${args[entry]}" -a ! "${args[entry]}" = true ] && echo "invalid entry ${args[entry]}" 1>&2 && exit 1
	args[no-custom]=${args[no-custom]-${args[nc]}}
	[ -n "${args[no-custom]}" -a ! "${args[no-custom]}" = true ] && echo "invalid no-custom ${args[no-custom]}" 1>&2 && exit 1

	# build command
	local cmd
	cmd="rofi -dmenu"
	cmd+=" -theme-str 'prompt {color: ${args[color]};}'"
	cmd+=" -matching ${args[matching]}"
	cmd+=" -theme-str 'window {width: ${args[width]}%;}'"
	cmd+=" -l ${args[lines]}"
	[ ! -z "${args[prompt]}}" ]   && cmd+=" -p '${args[prompt]}'"
	[ ! -z "${args[msg]}" ]		  && cmd+=" -mesg '${args[msg]}'"
	[ ! -z "${args[content]}" ]   && cmd+=" -theme-str \"entry {content: \\\"${args[content]}\\\";}\""
	[ ! -z "${args[input]}" ]     && cmd+=" -input '${args[input]}'"
	[ ! -z "${args[entry]}" ]     && cmd+=" -theme-str 'inputbar {padding: 2%; border: 0.1;}'"
	[ ! -z "${args[no-custom]}" ] && cmd+=" -no-custom"
	
	eval "$cmd"
}

if [[ "${BASH_SOURCE}" == "${0}" ]]; then
	ci3-rofi-dmenu "$@"
fi
