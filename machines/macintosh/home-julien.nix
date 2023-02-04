{ pkgs, lib, config, ... }:
{

  sops.secrets.ssh-macintosh-pub = {
    owner = "julien";
    path = "/home/julien/.ssh/id_ed25519.pub";
    mode = "0644";
    format = "binary";
    sopsFile = ../../secrets/ssh-macintosh-pub;
  };

  sops.secrets.ssh-macintosh-priv = {
    owner = "julien";
    path = "/home/julien/.ssh/id_ed25519";
    mode = "0600";
    format = "binary";
    sopsFile = ../../secrets/ssh-macintosh-priv;
  };

  luj.hmgr.julien =
    {
      home.stateVersion = "22.11";
      luj.programs.neovim.enable = true;
      luj.programs.ssh-client.enable = true;
      luj.programs.git.enable = true;
      luj.programs.gtk.enable = true;
      luj.programs.alacritty.enable = true;
      luj.programs.sway.enable = true;

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
          unstable.rofi
          fira-code
          unstable.firefox
          feh
          meld
          vlc
          nerdfonts
          font-awesome
          nodejs
          neomutt
          htop
          evince
          mosh
          flameshot
          networkmanagerapplet
          sops
        ];

      fonts.fontconfig.enable = true;

      home.keyboard = {
        layout = "fr";
      };


    };


}
