# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  home-manager.users.julien = {
    home.username = "julien";
    home.homeDirectory = "/home/julien";
    home.stateVersion = "21.11";
    imports = [ ../home-manager-modules/mails/default.nix ../home-manager-modules/neovim/default.nix ];
    luj.programs.neovim.enable = true;

  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/eaec3978-f462-4634-95e6-06d59512deb8";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/EAD2-51DB";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/c19ec918-ba8c-4bab-9ee0-831465cb432e"; }];

  nix.maxJobs = lib.mkDefault 8;

  # Specific to lisa but not hardware


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  luj.mediaserver.enable = true;
  luj.homepage.enable = true;
  networking.hostName = "lisa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = true;
  networking.interfaces.ens19.useDHCP = false;
  networking.interfaces.ens19.ipv6.addresses = [{
    address = "2a01:e0a:5f9:9681:5880:c9ff:fe9f:3dfb";
    prefixLength = 120;
  }];

  networking.firewall.allowedTCPPorts = [ 22 80 443 8096 8920 ];
  networking.firewall.allowedUDPPorts = [ 22 80 443 1900 7359 ];
  networking.firewall.allowedUDPPortRanges = [{ from = 60000; to = 61000; }];


  system.stateVersion = "20.09"; # Did you read the comment?




}
