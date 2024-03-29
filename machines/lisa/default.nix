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
    irc = {
      enable = true;
      nginx = {
        enable = true;
        subdomain = "irc";
      };
    };
    mediaserver = {
      enable = true;
      tv.enable = true;
      music.enable = true;
    };
    homepage.enable = true;
    docs = {
      enable = true;
      nginx = {
        enable = true;
        subdomain = "docs";
      };
    };
    homer.enable = true;
    mailserver.enable = true;
    linkal.enable = true;

  };


  # make the tailscale command usable to users
  environment.systemPackages = [ pkgs.tailscale pkgs.linkal ];

  # enable the tailscale service
  services.tailscale.enable = true;

  services.fail2ban.enable = true;

  networking.hostName = "lisa";
  networking.useDHCP = false;
  networking.interfaces.ens20.useDHCP = false;
  networking.interfaces.ens20.mtu = 1420;
  networking.interfaces.ens20.ipv4.addresses = [{ address = "212.129.40.11"; prefixLength = 32; }];
  networking.interfaces.ens18.useDHCP = true;
  networking.defaultGateway.interface = "ens20";
  networking.defaultGateway.address = "212.129.40.11";
  networking.interfaces.ens19.useDHCP = false;
  networking.interfaces.ens19.ipv6.addresses = [{
    address = "2a01:e0a:5f9:9681:5880:c9ff:fe9f:3dfb";
    prefixLength = 120;
  }];

  networking.hostId = "fbb334ae";
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "fd85:27e8:fc9::6/128" ];
      listenPort = 51820;
      privateKeyFile = "/root/wg-private";

      peers = [
        {
          allowedIPs = [ "fd85:27e8:fc9::/48" ];
          publicKey = "ZO8j0AwssAERtyJQO+o11pWAFKzkxTI5hmqHsfEy5Bo=";
          endpoint = "core01.rz.ens.wtf:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  services.openssh.extraConfig = ''
    HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub
    HostKey /etc/ssh/ssh_host_ed25519_key
    TrustedUserCAKeys /etc/ssh/ssh_user_key.pub
    MaxAuthTries 20
  '';


  networking.firewall.allowedTCPPorts = [ 51821 ];
  networking.firewall.allowedUDPPorts = [ 51821 ];

  system.stateVersion = "21.11";


}
