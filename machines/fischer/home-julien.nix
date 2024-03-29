{ pkgs, lib, config, ... }:
{

  luj.hmgr.julien =
    {
      home.stateVersion = "22.11";
      luj.programs.neovim.enable = true;
      luj.programs.ssh-client.enable = true;
      luj.programs.git.enable = true;
      luj.programs.gtk.enable = true;
      luj.programs.waybar.enable = true;
      luj.programs.waybar.interfaceName = "enp0s13f0u1u4u4";
      luj.programs.kitty.enable = true;
      luj.programs.alacritty.enable = true;
      luj.programs.dunst.enable = true;
      luj.programs.zsh.enable = true;
      luj.programs.emacs.enable = true;
      luj.programs.firefox.enable = true;
      luj.emails.enable = true;
      luj.programs.sway = {
        enable = true;
        modifier = "Mod1";
        background = ./wallpaper.jpg;
      };


      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        font = "Fira Font";
        theme = "DarkBlue";
      };


      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 15;
      };


      home.packages = with pkgs;
        [
          du-dust
          kitty
          jq
          lazygit
          fira-code
          feh
          meld
          vlc
          jftui
          nerdfonts
          libreoffice
          font-awesome
          nodejs
          neomutt
          htop
          evince
          mosh
          zotero
          flameshot
          networkmanagerapplet
          xdg-utils
          sops
          step-cli
          gh
          gh-dash
          cvc5
          signal-desktop-beta
          scli
          texlive.combined.scheme-full
        ];

      fonts.fontconfig.enable = true;

      home.keyboard = {
        layout = "fr";
      };


    };


}
