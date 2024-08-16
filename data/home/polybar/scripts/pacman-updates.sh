#!/bin/sh

cfd="$(realpath "$(dirname "${BASH_SOURCE}")")"
color_alert="$($cfd/../color.sh alert)"
color_primary="$($cfd/../color.sh primary)"
color_info="$($cfd/../color.sh info)"

output="$(pacman -Qu)"
count=0
[ -n "$output" ] && count="$(echo "$output" | wc -l)"

[ "$count" -gt 0 -a "$count" -le 10 ] && echo "$count" && exit 0
[ "$count" -gt 10 ] && echo "%{F$color_alert}${count}%{F-}" && exit 0
exit 1
