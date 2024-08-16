#!/usr/bin/env bash

mpris_print() {
    local status metadata artist title

    if ! status=$(playerctl status 2> /dev/null); then
        echo "{}"
    fi

    if [[ ! "${status}" =~ ^(Playing|Paused|Stopped)$ ]]; then
        return
    fi

    # Avoid "No player could handle this command..." message
    metadata=$(playerctl metadata)
    artist=$(echo "${metadata}" | grep "xesam:artist" | tr -s ' ' | cut -d ' ' -f 3-)
    title=$(echo "${metadata}" | grep "xesam:title" | tr -s ' ' | cut -d ' ' -f 3-)

    if [[ -n "${artist}" && -n "${title}" ]]; then
        echo "{\"text\": \"${artist} — ${title}\",\"alt\": \"${status@L}\"}"
    fi
}

follow_status() {
    playerctl --follow status --format "{{status}}" | while read -r _; do
        mpris_print
    done
}

follow_metadata() {
    playerctl --follow metadata --format "{{title}}" | while read -r _; do
        mpris_print
    done
}

follow_status &
follow_metadata
