#!/bin/bash

TODO_DIR="$(realpath "$HOME/.todo")"
TODO_CONFIG="${TODO_DIR}/config"
ARCHIVE_DIR="$TODO_DIR/archive"
source "$TODO_CONFIG"
APP_NAME='todo manager'

notify() { ci3-notify.sh --summary "$APP_NAME" "$@"; }
input_txt() { ci3-input.sh txt --app-name "$APP_NAME" "$@"; }
input_filepath() { ci3-input.sh filepath --app-name "$APP_NAME" --relative "$@"; }
input_num() { ci3-input.sh num --app-name "$APP_NAME" -p 'entry number' -w 17 "$@"; }

get_todo_file() {
	if ([[ "$1" == /* ]] || [[ "$1" == ~* ]]) && [ -f "$1" ]; then
		echo "$1"
		return 0
	elif [ -z "$1" ] || [ "$1" = "todo" ]; then
		echo "$TODO_CONFIG"
	else
		echo "${TODO_DIR}/$1"
	fi
}

restart_conky() {
	"$HOME/.config/conky/launch.sh" todo.rc -f
}

show_todo() {
	[ -z "$1" ] && return 0

	todo_file="$(get_todo_file "$1")"
	filename="$(basename "$todo_file")"
	if ! grep -E "^${filename} " "$HOME/.config/conky/todo.conf" 1>/dev/null 2>&1; then
		echo "$filename ${todo_file}-conky" >>"$HOME/.config/conky/todo.conf"
		restart_conky
	fi
}

hide_todo() {
	[ -z "$1" ] && return 0

	todo_file="$(get_todo_file "$1")"
	filename="$(basename "$todo_file")"
	if grep -E "^${filename} " "$HOME/.config/conky/todo.conf" 1>/dev/null 2>&1; then
		sed -i -E "/^${filename} /d" "$HOME/.config/conky/todo.conf"
		restart_conky
	fi
}

create_todo() {
	[ -z "$1" ] && return 0

	todo_file="$(get_todo_file "$1")"
	filename="$(basename "$todo_file")"
	[ -f "$todo_file" ] && return 0

	echo "source $TODO_CONFIG" >"$todo_file"
	echo "export TODO_FILE=\"\$TODO_DIR/$1.txt\"" >>"$todo_file"
	echo "export DONE_FILE=\"\$TODO_DIR/$1.done.txt\"" >>"$todo_file"
	echo "export REPORT_FILE=\"\$TODO_DIR/$1.report.txt\"" >>"$todo_file"

	echo "source ${TODO_DIR}/conky" >"${todo_file}-conky"
	echo "source ${TODO_DIR}/$1" >>"${todo_file}-conky"
}

remove_todo() {
	[ -z "$1" ] && return 0

	todo_file="$(get_todo_file "$1")"
	filename="$(basename "$todo_file")"
	hide_todo "$1"
	now="$(date +'%Y-%m-%d-%H-%M-%S')"
	[ ! -d "$ARCHIVE_DIR" ] && mkdir -p "$ARCHIVE_DIR"

	[ -f "${todo_file}" ] && mv "${todo_file}" "${ARCHIVE_DIR}/${now}-${filename}"
	[ -f "${todo_file}-conky" ] && mv "${todo_file}-conky" "${ARCHIVE_DIR}/${now}-${filename}-conky"
	[ -f "${todo_file}.txt" ] && mv "${todo_file}.txt" "${ARCHIVE_DIR}/${now}-${filename}.txt"
	[ -f "${todo_file}.txt.bak" ] && mv "${todo_file}.txt.bak" "${ARCHIVE_DIR}/${now}-${filename}.txt.bak"
	[ -f "${todo_file}.done.txt" ] && mv "${todo_file}.done.txt" "${ARCHIVE_DIR}/${now}-${filename}.done.txt"
	[ -f "${todo_file}.report.txt" ] && mv "${todo_file}.report.txt" "${ARCHIVE_DIR}/${now}-${filename}.report.txt"

	return 0
}

lsn() {
	[ -z "$2" ] && return 0
	echo "$(todo.sh -d "$(get_todo_file "$1")" lsn "$2")"
}

report_todo() {
	todo.sh -d "$(get_todo_file "$1")" report
}

add_entry() {
	[ -z "$2" ] && return 0
	todo.sh -d "$(get_todo_file "$1")" add "$2"
}

delete_entry() {
	[ -z "$2" ] && return 0
	todo.sh -f -d "$(get_todo_file "$1")" del "$2"
}

do_entry() {
	[ -z "$2" ] && return 0
	todo.sh -d "$(get_todo_file "$1")" done "$2"
}

update_entry() {
	[ -z "$3" ] && return 0
	todo.sh -d "$(get_todo_file "$1")" update "$2" "$3"
}

prio_entry() {
	[ -z "$3" ] && return 0
	todo.sh -d "$(get_todo_file "$1")" pri "$2" "$3"
}

deprio_entry() {
	[ -z "$2" ] && return 0
	todo.sh -d "$(get_todo_file "$1")" depri "$2"
}

move_entry() {
	[ -z "$3" ] && return 0
	todo.sh -f move "$1" "$2" "$3"
}

copy_entry() {
	[ -z "$2" ] && return 0
	todo.sh -d "$(get_todo_file "$1")" copy "$2"
}

store_todo_files() {
	echo "$TODO_CONFIG" >/tmp/todo-files
	find "${TODO_DIR}" -type f -not \( -name ".stignore" -o -name "*.report.txt" -o -name "*-conky" -o -name "*.done.txt" -o -name "*.txt" -o -name "*.txt.bak" -o -name "conky" \) -print >>/tmp/todo-files
}

showall() {
	[ -z "$1" ] && return 0
	filepath="$(get_todo_file "$1")"
	filename="$(basename "$file")"
	file="${TODO_DIR}/${filename}.txt"
	tmpfile="$(mktemp)"
	cat "$file" | nl -b a >"$tmpfile"
	selected="$(ci3-rofi-dmenu.sh -p "${filename} todos" -l 7 -i "${tmpfile}" -w 45 -nc)"
	[ -n "$selected" ] && echo "$selected" | xclip -selection clipboard
	return 0
}

revert() {
	[ -z "$2" ] && return 0
	todo.sh -d "$(get_todo_file "$1")" revert "$2"
}

select_file() {
	[ -z "$2" ] && return 1
	if [ "$(wc -l /tmp/todo-files | cut -d' ' -f1)" -eq 1 ]; then
		file="$(cat /tmp/todo-files)"
	else
		file="$(ci3-rofi-dmenu.sh -p "$1" -msg "$2" -l 3 -i /tmp/todo-files -w 45 -nc)"
	fi
	[ -z "$file" ] && notify -body 'filepath must not be empty' && return 0
	[ ! -f "$file" ] && notify -u critical -body "file doesnt exist $file" && return 0
	echo "$file"
}

select_line() {
	[ -z "$2" ] && return 0
	file="$2"
	tempfile="$(mktemp)"
	cat "$file" | nl -b a >"$tempfile"
	line="$(ci3-rofi-dmenu.sh -p 'select line' -msg "$1" -l 7 -nc -i "$tempfile" -w 45)"
	[ -z "$line" ] && return 0
	echo "$line" | awk -F' ' '{print $1}'
}

case "$1" in
add)
	store_todo_files
	file="$(select_file 'select todo file' 'to add entry')"
	[ ! -n "$file" ] && exit 1
	txt="$(input_txt -p 'entry' -w 50)"
	[ ! -n "$txt" ] && exit 1
	add_entry "$file" "$txt"
	;;
do)
	store_todo_files
	file="$(select_file 'select todo file' 'to do entry')"
	[ ! -n "$file" ] && exit 1
	num="$(input_num)"
	[ ! -n "$num" ] && exit 1
	do_entry "$file" "$num"
	;;
delete)
	store_todo_files
	file="$(select_file 'select todo file' 'to delete entry')"
	[ ! -n "$file" ] && exit 1
	num="$(input_num)"
	[ ! -n "$num" ] && exit 1
	delete_entry "$file" "$num"
	;;
update)
	store_todo_files
	file="$(select_file 'select todo file' 'to update entry')"
	[ ! -n "$file" ] && exit 1
	num="$(input_num)"
	[ ! -n "$num" ] && exit 1
	content="$(lsn "$file" "$num")"
	txt="$(ci3-rofi-dmenu.sh -p 'new entry' -l 0 -w 55 -entry -content "$content")"
	[ ! -n "$txt" ] && notify -body "text shouldnt be empty" && exit 1
	update_entry "$file" "$num" "$txt"
	;;
prio)
	store_todo_files
	file="$(select_file 'select todo file' 'to prioritize entry')"
	[ ! -n "$file" ] && exit 1
	num="$(input_num)"
	[ ! -n "$file" ] && exit 1
	prio="$(input_txt -p 'priority' -w 15)"
	[ ! -n "$prio" ] && exit 1
	[[ ! "$prio" =~ ^[A-Z]$ ]] && notify -body "value must be [A-Z] $prio" && exit 0
	prio_entry "$file" "$num" "$prio"
	;;
deprio)
	store_todo_files
	file="$(select_file 'select todo file' 'to deprioritize entry')"
	[ ! -n "$file" ] && exit 1
	num="$(input_num)"
	[ ! -n "$num" ] && exit 1
	deprio_entry "$file" "$num"
	;;
move)
	store_todo_files
	src_file="$(input_filepath -p 'SRC todo file' -m 'to move entry')"
	[ ! -n "$src_file" ] && exit 1
	num="$(input_num)"
	[ ! -n "$num" ] && exit 1
	dst_file="$(input_filepath -p 'DST todo file' -m 'to move entry')"
	[ ! -n "$num" ] && exit 1
	move_entry "$num" "$dst_file" "$src_file"
	;;
copy)
	store_todo_files
	file="$(select_file 'select todo file' 'to copy')"
	[ ! -n "$file" ] && exit 1
	num="$(input_num)"
	[ ! -n "$num" ] && exit 1
	copy_entry "$file" "$num"
	;;
showall)
	store_todo_files
	file="$(select_file 'select todo file' 'to show todos')"
	[ ! -n "$file" ] && exit 1
	showall "$file"
	;;
revert)
	store_todo_files
	file="$(select_file 'select todo file' 'to revert')"
	[ ! -n "$file" ] && exit 1
	source "$file"
	line_number="$(select_line 'to revert done task' "$DONE_FILE")"
	[[ ! "$line_number" =~ ^[0-9]+$ ]] && notify -body 'line number should be a number?!' && exit 0
	line="$(sed -n -e "${line_number}p" "$DONE_FILE")"
	[ ! -n "$line" ] && notify -body 'empty line must not be selected' && exit 0
	revert "$file" "$line_number"
	;;
create)
	txt="$(input_txt -p 'create todo file' -w 25)"
	[ ! -n "$txt" ] && exit 1
	create_todo "$txt"
	;;
Create)
	name="$(input_txt -p 'create todo file' -w 25)"
	[ ! -n "$name" ] && exit 1
	create_todo "$name"
	show_todo "$name"
	;;
remove)
	store_todo_files
	file="$(select_file 'select todo file' 'to remove')"
	[ ! -n "$file" ] && exit 1
	remove_todo "$file"
	;;
report)
	store_todo_files
	file="$(select_file 'select todo file' 'to report')"
	[ ! -n "$file" ] && exit 1
	report_todo "$file"
	;;
show)
	store_todo_files
	file="$(select_file 'select todo file' 'to show')"
	[ ! -n "$file" ] && exit 1
	show_todo "$file"
	;;
hide)
	store_todo_files
	file="$(select_file 'select todo file' 'to hide')"
	[ ! -n "$file" ] && exit 1
	hide_todo "$file"
	;;
esac
