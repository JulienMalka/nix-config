{ config, pkgs, lib, ... }:
let
  cfg = config.luj.programs.git;
in
with lib;
{
  options.luj.programs.git = {
    enable = mkEnableOption "Enable git program";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Julien Malka";
      userEmail = "julien.malka@me.com";
    };
  };
}