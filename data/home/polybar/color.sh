#!/bin/sh

[ -z "$1" ] && exit 0
file="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"/colors.ini
color="$(grep -Eo '^[^= ;]+ = #[0-9a-fA-F]+' "$file" | grep -E "^$1 = .*$" | cut -d'=' -f2 | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*$//g')"
[ -z "$color" ] && exit 0
echo "$color"
exit 0
