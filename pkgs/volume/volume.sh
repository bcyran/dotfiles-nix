#!/usr/bin/env bash
#
# A script to control the audio volume of the default WirePlumber sink
# using wpctl as a backend.

set +o nounset

LC_ALL=C # To avoid decimal point problems

SINK='@DEFAULT_AUDIO_SINK@'
MAX_VOLUME='1.0' # Do not allow setting volume larger than that
readonly SINK MAX_VOLUME

progname="$(basename "$0")"
readonly progname

int() {
    printf '%.0f' "$1"
}

calc() {
    echo "scale=5; $*" | bc
}

bound() {
    if [[ "$3" -lt "$1" ]]; then
        echo "$1"
    elif [[ "$3" -gt "$2" ]]; then
        echo "$2"
    else
        echo "$3"
    fi
}

is_number() {
    if [[ $1 =~ ^[0-9]+$ ]]; then
        true
    else
        false
    fi
}

get_volume() {
    wpctl get-volume ${SINK} | cut -d ' ' -f 2
}

get_volume_percent() {
    int "$(calc "$(get_volume) * 100")"
}

set_volume() {
    wpctl set-volume --limit ${MAX_VOLUME} ${SINK} "$1"
}

set_volume_percent() {
    local new_volume_decimal
    new_volume_decimal="$(calc "$1 / 100")"
    set_volume "${new_volume_decimal}"
}

print_volume() {
    echo "$(get_volume_percent)%"
}

inc_volume() {
    set_volume "${1}%+"
}

dec_volume() {
    set_volume "${1}%-"
}

mute() {
    wpctl set-mute ${SINK} 1
}

unmute() {
    wpctl set-mute ${SINK} 0
}

toggle_mute() {
    wpctl set-mute ${SINK} toggle
}

print_help() {
    echo "Usage: ${progname} [-h|--help] {set|get|up|down|mute|unmute|toggle} [VALUE]"
    echo "Control volume of the default pulseaudio sink."
}

usage_err() {
    echo "${progname}: $1" >&2
    print_help
    exit 1
}

command="$1"
value="${2%\%}" # Allow for '%' in value
readonly command value

case "${command}" in
    set)
        [[ -n "${value}" ]] || usage_err 'missing VALUE'
        is_number "${value}" || usage_err 'VALUE must be a number'
        set_volume_percent "${value}"
        ;;
    get)
        print_volume
        ;;
    up)
        is_number "${value:-5}" || usage_err 'VALUE must be a number'
        inc_volume "${value:-5}"
        ;;
    down)
        is_number "${value:-5}" || usage_err 'VALUE must be a number'
        dec_volume "${value:-5}"
        ;;
    mute)
        mute
        ;;
    unmute)
        unmute
        ;;
    toggle)
        toggle_mute
        ;;
    -h | ?-help)
        print_help
        ;;
    *)
        usage_err "invalid argument '${command}'"
        ;;
esac
