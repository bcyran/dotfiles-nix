{
  config,
  inputs,
  ...
}: let
  inherit (config.colorScheme) palette;
  inherit (inputs.nix-colors.lib.conversions) hexToRGBString;
in {
  programs.zathura = {
    enable = true;
    mappings = {
      "<C-i>" = "zoom in";
      "<C-o>" = "zoom out";
    };
    options = {
      window-title-basename = true;
      selection-clipboard = "clipboard";
      font = "JetBrainsMono Nerd Font normal 14";
      scroll-step = 100;

      default-bg = "#${palette.base00}";
      default-fg = "#${palette.base05}";
      statusbar-bg = "#${palette.base01}";
      statusbar-fg = "#${palette.base05}";
      inputbar-bg = "#${palette.base00}";
      inputbar-fg = "#${palette.base05}";
      notification-bg = "#${palette.base00}";
      notification-fg = "#${palette.base05}";
      notification-error-bg = "#${palette.base00}";
      notification-error-fg = "#${palette.error}";
      notification-warning-bg = "#${palette.base00}";
      notification-warning-fg = "#${palette.warning}";
      highlight-color = "rgba(${hexToRGBString "," palette.accentSecondary},0.5)";
      highlight-active-color = "rgba(${hexToRGBString "," palette.accentPrimary},0.5)";
      recolor-lightcolor = "#${palette.base00}";
      recolor-darkcolor = "#${palette.base05}";
      index-bg = "#${palette.base00}";
      index-fg = "#${palette.base05}";
      index-active-bg = "#${palette.accentPrimary}";
      index-active-fg = "#${palette.base00}";
    };
  };
}
