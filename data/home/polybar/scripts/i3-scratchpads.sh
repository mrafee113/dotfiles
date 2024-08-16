#!/usr/bin/sh

count="$(i3-msg -t get_tree | jq '.. | .floating_nodes?[]? | select(type == "object" and (.scratchpad_state == "fresh" or .scratchpad_state == "changed") and .output != "DP-2")' | grep -cE 'fresh|changed')"
if [ "$count" -gt 0 ]; then
	echo "$count"
	exit 0
fi
echo
exit 1
