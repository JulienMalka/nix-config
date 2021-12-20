{ pkgs, config, lib, ... }:
{
  luj.hmgr.julien = {
    luj.programs.neovim.enable = true;
    luj.programs.git.enable = true;
    luj.emails = {
      enable = true;
      backend.enable = true;
    };
  };
}
