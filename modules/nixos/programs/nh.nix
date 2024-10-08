{
  config,
  lib,
  ...
}: let
  cfg = config.my.programs.nh;
in {
  options.my.programs.nh.enable = lib.mkEnableOption "nh";

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = config.my.user.configDir;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 10 --keep-since 14d";
      };
    };
  };
}
