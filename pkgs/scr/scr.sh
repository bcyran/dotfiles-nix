#!/usr/bin/env bash

set +o nounset

SCR_DIR="${MY_SCREENSHOTS_DIR:-$(xdg-user-dir PICTURES)/Screenshots}"

get_shot_path() {
    echo "${SCR_DIR}/$(date '+%Y-%m-%d_%H:%M:%S').png"
}

notify() {
    local notif_action
    notif_action="$(notify-send --app-name scr --action='open_image=Open the image' --action='open_dir=Open the directory' --icon "$1" 'Screenshot taken' "Saved as $1")"
    case ${notif_action} in
        "open_image")
            gio open "$1"
            ;;
        "open_dir")
            gio open "$(dirname "$1")"
            ;;
    esac

}

notify_if_saved() {
    if [[ -f "$1" ]]; then
        notify "$1"
    fi
}

annotate_fullscreen() {
    hyprctl keyword windowrulev2 'fullscreen,title:^(satty)$' > /dev/null
    hyprctl keyword windowrulev2 'float,title:^(satty)$' > /dev/null
    hyprctl keyword windowrulev2 'noanim,title:^(satty)$' > /dev/null
    satty --disable-notifications --filename - --fullscreen --save-after-copy --early-exit --output-filename "$1"
    hyprctl keyword windowrulev2 'unset,title:^(satty)$' > /dev/null
}

annotate_floating() {
    hyprctl keyword windowrulev2 'float,title:^(satty)$' > /dev/null
    hyprctl keyword windowrulev2 'noanim,title:^(satty)$' > /dev/null
    satty --disable-notifications --filename - --save-after-copy --early-exit --output-filename "$1"
    hyprctl keyword windowrulev2 'unset,title:^(satty)$' > /dev/null
}

print_usage() {
    echo "usage: $0 {active|screen|output|area}

Targets:
  active: active window
  screen: entire screen
  output: active output
  area: selected area"
}

if ! [[ -d "${SCR_DIR}" ]]; then
    mkdir -p "${SCR_DIR}"
fi

shot_path="$(get_shot_path)"

case "$1" in
    active)
        grimblast save active "${shot_path}" > /dev/null
        ;;
    screen)
        grimblast save screen "${shot_path}" > /dev/null
        ;;
    output)
        grimblast save output - | annotate_fullscreen "${shot_path}"
        ;;
    area)
        grimblast save area - | annotate_floating "${shot_path}"
        ;;
    --help | -h | *)
        print_usage
        ;;
esac

notify_if_saved "${shot_path}"
