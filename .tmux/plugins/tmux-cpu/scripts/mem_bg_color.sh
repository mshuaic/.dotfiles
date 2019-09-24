#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

mem_low_bg_color=""
mem_medium_bg_color=""
mem_high_bg_color=""

mem_low_default_bg_color="#[bg=green]"
mem_medium_default_bg_color="#[bg=yellow]"
mem_high_default_bg_color="#[bg=red]"

get_bg_color_settings() {
	mem_low_bg_color=$(get_tmux_option "@mem_low_bg_color" "$mem_low_default_bg_color")
	mem_medium_bg_color=$(get_tmux_option "@mem_medium_bg_color" "$mem_medium_default_bg_color")
	mem_high_bg_color=$(get_tmux_option "@mem_high_bg_color" "$mem_high_default_bg_color")
}

print_bg_color() {
	local mem_percentage=$($CURRENT_DIR/mem_percentage.sh | sed -e 's/%//')
	local mem_load_status=$(cpu_load_status $mem_percentage)
	if [ $mem_load_status == "low" ]; then
		echo "$mem_low_bg_color"
	elif [ $mem_load_status == "medium" ]; then
		echo "$mem_medium_bg_color"
	elif [ $mem_load_status == "high" ]; then
		echo "$mem_high_bg_color"
	fi
}

main() {
	get_bg_color_settings
	print_bg_color
}
main
