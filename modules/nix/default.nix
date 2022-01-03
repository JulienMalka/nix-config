{ pkgs, config, lib, inputs, ... }:
let
  cfg = config.luj.nix;
in
with lib;
{
  options.luj.nix = {
    enable = mkEnableOption "Enable nix experimental";
  };

  config = mkIf cfg.enable
    {
      nixpkgs.config.allowUnfree = true;
      nix = {
        autoOptimiseStore = true;
        gc = {
          automatic = true;
          dates = "weekly";
        };
        package = pkgs.nixUnstable;
        extraOptions = ''
          experimental-features = nix-command flakes
          narinfo-cache-negative-ttl = 0
        '';
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          "nixos=${inputs.nixpkgs}"
        ];
        binaryCaches = [
          "https://bin.julienmalka.me"
        ];
        binaryCachePublicKeys = [
          "bin.julienmalka.me:y0uADfX8ZQ6Pthofm8Pj7v+hED3m2cY0d+Sg6/Jm+s8="
        ];

      };


    };
}
