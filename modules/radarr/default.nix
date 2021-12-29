{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.luj.radarr;
  port = 7878;
in
{

  options.luj.radarr = {

    enable = mkEnableOption "activate radarr service";

    user = mkOption {
      type = types.str;
      default = "radarr";
      description = "User account under which Radarr runs.";
    };

    group = mkOption {
      type = types.str;
      default = "radarr";
      description = "Group under which Radarr runs.";
    };

    nginx.enable = mkEnableOption "activate nginx";
    nginx.subdomain = mkOption {
      type = types.str;
    };

  };

  config = mkIf cfg.enable (
    mkMerge [{
      services.radarr = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
      };
    }

      (mkIf cfg.nginx.enable (mkSubdomain cfg.nginx.subdomain port))

    ]);





}
