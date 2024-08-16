#!/bin/sh

[ -z "$1" ] && exit 1

if [ "$1" = cpu ]; then
	cpu="$(sensors 2>/dev/null | grep "cpu_fan:" 2>/dev/null | awk '{print $2}' 2>/dev/null)"
	[ -z "$cpu" ] && exit 1
	echo "$cpu"
	exit 0
elif [ "$1" = gpu ]; then
	gpu="$(sensors 2>/dev/null | grep "gpu_fan:" 2>/dev/null | awk '{print $2}' 2>/dev/null)"
	[ -z "$gpu" ] && exit 1
	echo "$gpu"
	exit 0
else
	exit 1
fi
