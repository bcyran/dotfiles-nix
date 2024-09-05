{
  config,
  lib,
  ...
}: let
  cfg = config.my.programs.hyprland;
in {
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "float, class:terminal-floating"
        "size 800 500, class:terminal-floating"

        "float, title:PhilipsTV GUI"
        "monitor $monitorC, class:PhilipsTV GUI"
        "size 250 700, title:PhilipsTV GUI"
        "move 100%-270 70, title:PhilipsTV GUI"

        "float, class:KeePassXC"
        "monitor $monitorC, class:KeePassXC"
        "size 1000 700, class:KeePassXC"
        "center, class:KeePassXC"

        "float, class:MEGAsync"
        "monitor $monitorC, class:MEGAsync"
        "move 100%-420 70, class:MEGAsync"

        "float, class:protonvpn"
        "monitor $monitorC, class:protonvpn"
        "size 400 760, class:protonvpn"
        "move 100%-420 70, class:protonvpn"

        "float, title:splash"
        "float, title:Android Emulator"

        "float, class:org.gnome.Calculator"
        "size 400 500, class:org.gnome.Calculator"
        "move 100%-420 100%-520, class:org.gnome.Calculator"

        "workspace 11 silent, class:Spotify"
        "workspace 9 silent, class:Signal"
        "workspace 8, class:Obsidian"
        "float, title:Postęp działań na plikach"
      ];
    };
  };
}
