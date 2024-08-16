#!/usr/bin/env bash

polybar-msg cmd quit
[ "$1" = -q ] && exit

# polybar 2>&1 | tee -a /tmp/polybar.log & disown

echo "---" | tee -a /tmp/polybar-1.log /tmp/polybar-2.log
# polybar bar-1 2>&1 | tee -a /var/log/polybar-bar-1.log & disown
ci3.sh --cmd 'exec --no-startup-id "polybar bar-1 1>>/var/log/francis/polybar-bar-1.log 2>>/var/log/francis/polybar-bar-1.errlog & disown"'
# polybar bar-2 2>&1 | tee -a /var/log/polybar-bar-2.log & disown
ci3.sh --cmd 'exec --no-startup-id "polybar bar-2 1>>/var/log/francis/polybar-bar-2.log 2>>/var/log/francis/polybar-bar-2.errlog & disown"'

# just an attempt
# ci3.sh --cmd cmd args 1>>(date +'%Y-%m-%d %H:%M:%S') >> /var/log/cmd.log 2>>(date +'%Y-%m-%d %H:%M:%S') >> /var/log/cmd.errlog
# polybar bar-1 1>>$(date +%Y-%m-%d--%H:%M:%S) >> /var/log/francis/polybar-bar-1.log 2>>$(date +%Y-%m-%d--%H:%M:%S) >> /var/log/francis/polybar-bar-1.errlog & disown
# polybar bar-2 1>>$(date +%Y-%m-%d--%H:%M:%S) >> /var/log/francis/polybar-bar-2.log 2>>$(date +%Y-%m-%d--%H:%M:%S) >> /var/log/francis/polybar-bar-2.errlog & disown
# ci3.sh --cmd 'exec --no-startup-id "polybar bar-2 1>>/var/log/francis/polybar-bar-2.log 2>>/var/log/francis/polybar-bar-2.errlog & disown"'
