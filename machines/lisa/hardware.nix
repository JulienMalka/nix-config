{ pkgs, config, lib, ... }:
{
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.kernelPackages = pkgs.linuxPackages_5_17;

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 fileSystems."/" =
    {
      device = "zroot/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/4E38-3626";
      fsType = "vfat";
    };
swapDevices = [];


boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [ /boot/initrd-ssh-key ];
      authorizedKeys = lib.splitString "\n" 
    (builtins.readFile (pkgs.fetchurl {
      url = "https://github.com/JulienMalka.keys";
      sha256 = "sha256-/i6WOEWBfXnRln9r6GCznoc47UzN+jInkWjTSqNafHI=";
    }));

    };
    postCommands = ''
      zpool import zroot
      echo "zfs load-key -a; killall zfs" >> /root/.profile
    '';
  };




}
