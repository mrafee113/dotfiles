#!/bin/sh

temp="$(nvidia-settings -q gpucoretemp -t)"
echo "$temp"

[ "$temp" -ge 65 ] && exit 1
exit 0
