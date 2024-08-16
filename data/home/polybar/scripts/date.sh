#!/bin/sh

# presumes that python jdatetime is installed system-wide

cfd="$(realpath "$(dirname "${BASH_SOURCE}")")"
color_alert="$($cfd/../color.sh alert)"
color_primary="$($cfd/../color.sh primary)"
color_info="$($cfd/../color.sh info)"

jdate="$(python -c 'import jdatetime; print(jdatetime.datetime.now().date().strftime("%d %B %Y"))')"
jdate_day="$(echo "$jdate" | cut -d' ' -f1)"
jdate_month="$(echo "$jdate" | cut -d' ' -f2)"
jdate_year="$(echo "$jdate" | cut -d' ' -f3)"

gdate="$(date +"%d %b %m %Y")"
gdate_day="$(echo "$gdate" | cut -d' ' -f1)"
gdate_month="$(echo "$gdate" | cut -d' ' -f2)"
gdate_month_num="$(echo "$gdate" | cut -d' ' -f3)"
gdate_year="$(echo "$gdate" | cut -d' ' -f4)"

day="$(date +%a)"
time="$(date +"%H:%M:%S")"

day_color=
case "$day" in
	Sat) day_color="#924CC4" ;;
	Sun) day_color="#EE82EE" ;;
	Mon) day_color="#FF0000" ;;
	Tue) day_color="#FFA500" ;;
	Wed) day_color="#FFFF00" ;;
	Thu) day_color="#008000" ;;
	Fri) day_color="#0000FF" ;;
esac

month_color=
season_color=
season=
case "$gdate_month_num" in
	12) month_color="#872424" ; season_color="#924CC4" ; season= ;;
	01) month_color="#7A2F75" ; season_color="#924CC4" ; season= ;;
	02) month_color="#924CC4" ; season_color="#924CC4" ; season= ;;
	03) month_color="#388C93" ; season_color="#389341" ; season=󰉊 ;;
	04) month_color="#389341" ; season_color="#389341" ; season=󰉊 ;;
	05) month_color="#87A043" ; season_color="#389341" ; season=󰉊 ;;
	06) month_color="#98A043" ; season_color="#BF852F" ; season= ;;
	07) month_color="#BF852F" ; season_color="#BF852F" ; season= ;;
	08) month_color="#BF692F" ; season_color="#BF852F" ; season= ;;
	09) month_color="#BF582F" ; season_color="#BA3B2A" ; season=󰲓 ;;
	10) month_color="#BA3B2A" ; season_color="#BA3B2A" ; season=󰲓 ;;
	11) month_color="#BA2A3D" ; season_color="#BA3B2A" ; season=󰲓 ;;
esac

season="%{F$season_color}${season}%{F-}"
time="%{F$color_info}${time}%{F-}"
jdate_year="%{F$color_info}${jdate_year}%{F-}"
gdate_year="%{F$color_info}${gdate_year}%{F-}"

day="%{F$day_color}${day}%{F-}"
jdate_day="%{F$day_color}${jdate_day}%{F-}"
gdate_day="%{F$day_color}${gdate_day}%{F-}"

jdate_month="%{F$month_color}${jdate_month}%{F-}"
gdate_month="%{F$month_color}${gdate_month}%{F-}"
gdate_month_num="%{F$month_color}${gdate_month_num}%{F-}"

jdate="$jdate_day $jdate_month $jdate_year"
gdate="$gdate_day $gdate_month($gdate_month_num) $gdate_year"

label="%{F$color_primary}󱑆%{F-} ${time} ${day} %{F$color_primary}%{F-} ${jdate} %{F$color_primary}%{F-} ${gdate} ${season}"
echo "$label"
exit 0
