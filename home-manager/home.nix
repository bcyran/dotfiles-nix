#This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  pkgs,
  config,
  ...
}: let
  rofi = import ./features/rofi {inherit pkgs config;};
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./features/git.nix
    ./features/tmux.nix
    ./features/fish.nix
    ./features/alacritty.nix
    ./features/hyprland.nix
    ./features/dunst.nix
    ./features/swayidle.nix
    ./features/wlsunset.nix
    ./features/swaylock.nix
    ./features/ssh.nix
    ./features/zathura.nix
    ./features/btop.nix
    ./features/keepassxc.nix
    ./features/onagre
    ./features/waybar
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "bazyli";
    homeDirectory = "/home/bazyli";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    wget
    curl
    ranger
    neofetch
    roboto
    libnotify
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
    cargo
    rustc
    nodejs
    alejandra
    my.backlight
    my.volume
    my.wallpaper
    my.scr
    xfce.thunar
    rofi.appmenu
    rofi.powermenu
    rofi.calc
    rofi.runmenu
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.firefox.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
