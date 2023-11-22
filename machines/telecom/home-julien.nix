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
      luj.programs.sway.enable = true;
      luj.programs.waybar.enable = true;
      luj.programs.waybar.interfaceName = "enp0s13f0u1u4u4";
      luj.programs.kitty.enable = true;
      luj.programs.dunst.enable = true;
      luj.programs.zsh.enable = true;
      luj.emails.enable = true;

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
        x11 = {
          enable = true;
          defaultCursor = "Adwaita";
        };
      };

      xsession.enable = true;
      xsession.windowManager.command = "${pkgs.swayfx}/bin/sway";


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
          nixpkgs-patched.signal-desktop-beta
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


      programs.chromium = {
        enable = true;
        commandLineArgs = [
          "--ozone-platform-hint=wayland"
          "--load-media-router-component-extension=1"
        ];
        extensions = [
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
          { id = "ldlghkoiihaelfnggonhjnfiabmaficg"; } # Alt+Q switcher
          { id = "enjjhajnmggdgofagbokhmifgnaophmh"; } # Resolution Zoom for HiDPI
          { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I don't care about cookies
          { id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; } # Zotero Connector
          { id = "hlepfoohegkhhmjieoechaddaejaokhf"; } # Refined GitHub
          { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
          { id = "dcpihecpambacapedldabdbpakmachpb"; updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml"; }
        ];
      };


    };


}
