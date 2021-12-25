{ config, pkgs, lib, modulesPath, ... }:
let
  hostName = "newton";
in
{

  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware.nix
      ./home-julien.nix
    ];

  luj = {
    filerun.enable = true;
    zfs-mails.enable = true;
  };

  programs.gnupg.agent.enable = true;

  networking.hostName = hostName; # Define your hostname.
  networking.hostId = "f7cdfbc9";
  networking.interfaces.enp2s0f0.useDHCP = true;
  networking.interfaces.enp2s0f1.useDHCP = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 ];


  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  system.stateVersion = "21.05"; # Did you read the comment?

}
