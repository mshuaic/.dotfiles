#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
# source "$CURRENT_DIR/shared.sh"

mem_value() {
    if [ -x "$custom_percentage" ];then
        eval "$custom_percentage"
    elif is_osx; then
        if [ "$ignore_cached" == "yes" ]; then
            top -l 1 |\
            grep 'PhysMem' |\
            sed 's/[^0-9 ]*//g' |\
            awk '{f = $3}{"sysctl hw.memsize" | getline}{d = $2/1024/1024}{printf("%02d\n", 100*(d-f)/d)}'
        else
            top -l 1 |\
            grep 'PhysMem' |\
            sed 's/[^0-9 ]*//g' |\
            awk '{f = $2+$3}{"sysctl hw.memsize" | getline}{d = $2/1024/1024}{printf("%02d\n", 100*(d-f)/d)}'
        fi
    elif command_exists "free"; then
        if [ "$ignore_cached" == "yes" ]; then
            free |\
            grep 'Mem' |\
            awk '{d = $2/100}{printf("%02d\n", $3/d)}'
        else
            free |\
            grep 'Mem' |\
            awk '{d = $2/100}{m = $3+$6}{printf("%d\n", m/d)}'
        fi
    elif command_exists "top"; then
        if [ "$ignore_cached" == "yes" ]; then
            top -d 0.5 -b -n 2 |\
            grep 'Mem' |\
            tail -2 |\
            xargs |\
            awk '{d = $3/100}{m = $5-$19}{printf("%02d\n", m/d)}'
        else
            top -d 0.5 -b -n 2 |\
            grep 'Mem:' |\
            tail -1 |\
            awk '{d = $3/100}{printf("%02d\n", $5/d)}'
        fi
    fi
}

mem_percentage() {
    local mem_p=$(mem_value)
    echo $mem_p
    # if [ -z "$mem_p" ]; then
    #     print_color "error" "EE"
    # elif [ "$mem_p" -gt "$high_percentage" ]; then
    #     print_color "high" "$mem_p"
    # elif [ "$mem_p" -gt "$mid_percentage" ]; then
    #     print_color "mid" "$mem_p"
    # else
    #     print_color "low" "$mem_p"
    # fi
}

main() {
#    init_vars
    mem_percentage
}
main

