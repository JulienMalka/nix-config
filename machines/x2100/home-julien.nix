{ pkgs, lib, config, ... }:
{

  luj.hmgr.julien =
    {
      home.stateVersion = "22.11";
      luj.programs.neovim.enable = true;
      luj.programs.ssh-client.enable = true;
      luj.programs.git.enable = true;
      luj.programs.gtk.enable = true;
      luj.programs.alacritty.enable = true;
      luj.programs.waybar.enable = true;
      luj.programs.waybar.interfaceName = "wlp3s0";
      luj.programs.kitty.enable = true;
      luj.programs.zsh.enable = true;
      luj.emails.enable = true;
      luj.programs.firefox.enable = true;
      luj.programs.sway = {
        enable = true;
        modifier = "Mod4";
        background = ./wallpaper.jpg;
      };

      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        font = "Fira Font";
        theme = "DarkBlue";
      };

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 15;
        x11 = {
          enable = true;
          defaultCursor = "Adwaita";
        };
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
          emacs-pgtk
          vlc
          jftui
          nerdfonts
          libreoffice
          font-awesome
          cantarell-fonts
          nodejs
          neomutt
          htop
          evince
          mosh
          obsidian
          zotero
          flameshot
          kitty
          networkmanagerapplet
          element-desktop
          xdg-utils
          sops
          step-cli
          coq
          gh
          gh-dash
          cvc5
          signal-desktop-beta
          coqPackages.coqide
          (why3.withProvers
            [
              unstable.cvc4
              alt-ergo
              z3
            ])
          libsForQt5.neochat
          scli
          texlive.combined.scheme-full
        ];

      fonts.fontconfig.enable = true;

      home.keyboard = {
        layout = "fr";
      };

      services.dunst = {
        enable = true;
      };

    };


}
