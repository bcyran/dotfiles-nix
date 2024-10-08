# The following functions are intended to be used to create NixOS and Home Manager configurations
# relying on this flake. Such configurations are defined in the `hosts` dir of this flake,
# but can be also defined in other flakes using this flake as an input.
# They ensure that `my` (this flake) is always passed to the configuration modules and that
# `my.pkgs` is a set of packages exported by this flake for the target system.
#
# `my` should always refer to this flake. In this flake it's just `self`, but in other flakes
# it will by `inputs.my`.
{lib, ...}: {
  # Creates a NixOS system configuration.
  mkSystem = {
    inputs,
    name,
    system,
    my,
    extraModules ? [],
    extraInstallerModules ? [],
    specialArgs ? {},
  }: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      modules =
        ["${inputs.self}/hosts/${name}/nixos/configuration.nix"]
        ++ extraModules;
      specialArgs =
        {
          inherit inputs;
          my = my // {pkgs = my.packages.${system};};
        }
        // specialArgs;
    };
    "${name}-installer" = inputs.nixpkgs.lib.nixosSystem {
      modules =
        [
          inputs.disko.nixosModules.disko
          inputs.lanzaboote.nixosModules.lanzaboote
          my.nixosModules.default

          "${inputs.self}/hosts/${name}/common/user.nix"
          "${inputs.self}/hosts/${name}/nixos/disks.nix"
          "${inputs.self}/hosts/${name}/nixos/hardware-configuration.nix"

          ({pkgs, ...}: {
            networking.hostName = name;
            boot.loader.systemd-boot.enable = true;
            services.openssh = {
              enable = true;
              settings = {
                PermitRootLogin = "yes";
              };
            };
            my.presets.base.enable = true;
          })
        ]
        ++ extraInstallerModules;
      specialArgs =
        {
          inherit inputs;
          my = my // {pkgs = my.packages.${system};};
        }
        // specialArgs;
    };
  };

  # Creates a Home Manager configuration.
  mkHome = {
    inputs,
    name,
    system,
    my,
    extraModules ? [],
    specialArgs ? {},
  }: let
    nameSplit = lib.strings.splitString "@" name;
    user = builtins.elemAt nameSplit 0;
    host = builtins.elemAt nameSplit 1;
  in {
    ${name} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."${system}";
      modules =
        ["${inputs.self}/hosts/${host}/home-manager/${user}.nix"]
        ++ extraModules;
      extraSpecialArgs =
        {
          inherit inputs;
          my = my // {pkgs = my.packages.${system};};
        }
        // specialArgs;
    };
  };
}
