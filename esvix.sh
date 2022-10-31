#!/usr/bin/env bash

# Data: 12/10/2022

ui=
items=
message=
zenity_exists=
readonly FAILURE=1
readonly TRASH_PATH="$HOME"/.local/share/Trash/files

check_ui() {
	[[ $TERM = 'dumb' ]] && echo 'gui' || echo 'cli'
}

display_message() {
	local readonly TITLE='Esvix'

	if [ "$ui" = 'cli' ]; then
		echo $2
	else
		case $1 in
			'info')
				zenity --title="$TITLE" --info --text="$2" &;;
			'error')
				zenity --title="$TITLE" --error --text="$2" &;;
			*)
				exit $FAILURE
		esac
	fi
}

ui=`check_ui`
zenity --version > /dev/null 2> /dev/null
zenity_exists=$?

if [[ "$ui" = 'gui' && $zenity_exists -ne 0 ]]; then
	exit $FAILURE
fi

items=`ls "$TRASH_PATH" | wc -l`
if [ $items -gt 0 ]; then
	rm -rf "$TRASH_PATH"/*

	message='Empty trash can!'
	display_message 'info' "$message"
else
	message='The trash is already empty!'
	display_message 'error' "$message"
fi
