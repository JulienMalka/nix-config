{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
      ./hardware.nix
      ./home-julien.nix
      ../../users/julien.nix
      ../../users/default.nix
    ];


  luj = {
    irc.enable = true;
    mediaserver = {
      enable = true;
      tv.enable = true;
      music.enable = true;
    };
    homepage.enable = true;
    bincache = {
      enable = true;
      subdomain = "bin";
    };
    drone = {
      enable = true;
      subdomain = "ci";
    };
    zfs-mails = {
      enable = false;
      name = "lisa";
      smart.enable = false;
    };
    docs = {
      enable = true;
      nginx = {
        enable = true;
        subdomain = "docs";
      };
    };
    homer.enable = true;
    bruit = {
      enable = true;
      nginx = {
        enable = true;
        subdomain = "bruit";
      };
    };
    mailserver.enable = true;

  };



  # make the tailscale command usable to users
  environment.systemPackages = [ pkgs.tailscale ];

  # enable the tailscale service
  services.tailscale.enable = true;


  nix.maxJobs = lib.mkDefault 4;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.fail2ban.enable = true;

  networking.hostName = "lisa";
  networking.interfaces.ens20.useDHCP = false;
  networking.interfaces.ens20.ipv4.addresses = [{ address = "212.129.40.11"; prefixLength = 32; }];
  networking.localCommands = ''
    ip r del default || ip r add default dev ens20
  '';
  networking.interfaces.ens18.useDHCP = true;
  networking.interfaces.ens19.useDHCP = false;
  networking.interfaces.ens19.ipv6.addresses = [{
    address = "2a01:e0a:5f9:9681:5880:c9ff:fe9f:3dfb";
    prefixLength = 120;
  }];

  networking.nameservers = [ "100.127.245.71" "9.9.9.9" ];
  environment.etc."resolv.conf" = with lib; with pkgs; {
    source = writeText "resolv.conf" ''
      ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
      options edns0
    '';
  };

  networking.hostId = "fbb334ae";
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  system.stateVersion = "21.11";



  services.nginx.virtualHosts."jellyfin.mondon.me" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://100.74.49.77";
    };
  };

}
