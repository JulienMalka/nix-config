{ config, pkgs, lib, modulesPath, ... }:
let
  hostName = "newton";
in
  {
  
  #programs.home-manager.enable = true;
  home-manager.users.julien = {
  home.username = "julien";
  home.homeDirectory = "/home/julien";
  home.stateVersion = "21.11"; 
  imports = [../home-manager-modules/mails/default.nix ../home-manager-modules/neovim/default.nix ../home-manager-modules/git/default.nix ];
  luj.emails = {
      enable = true;
      backend.enable = true;
    };
	
   luj.programs.neovim.enable = true;
   luj.programs.git.enable = true;

  };
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = false;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.loader.grub.mirroredBoots = [
    { path = "/boot-1"; devices = [ "/dev/disk/by-id/ata-WDC_WD20EFRX-68EUZN0_WD-WCC4M1TVUVJV" ]; }
    { path = "/boot-2"; devices = [ "/dev/disk/by-id/ata-WDC_WD20EFRX-68EUZN0_WD-WCC4M7UDRLSK" ]; }
  ];

  programs.gnupg.agent.enable = true;
  networking.hostName = hostName; # Define your hostname.
  networking.hostId = "f7cdfbc9";

  time.timeZone = "Europe/Paris";

  networking.useDHCP = false;
  networking.interfaces.enp2s0f0.useDHCP = true;
  networking.interfaces.enp2s0f1.useDHCP = true;

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;
  boot.initrd.network = {
    # This will use udhcp to get an ip address.
    # Make sure you have added the kernel module for your network driver to `boot.initrd.availableKernelModules`, 
    # so your initrd can load it!
    # Static ip addresses might be configured using the ip argument in kernel command line:
    # https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      # To prevent ssh clients from freaking out because a different host key is used,
      # a different port for ssh is useful (assuming the same host has also a regular sshd running)
      # hostKeys paths must be unquoted strings, otherwise you'll run into issues with boot.initrd.secrets
      # the keys are copied to initrd from the path specified; multiple keys can be set
      # you can generate any number of host keys using 
      # `ssh-keygen -t ed25519 -N "" -f /path/to/ssh_host_ed25519_key`
      hostKeys = [ /boot-1/initrd-ssh-key /boot-2/initrd-ssh-key ];
      # public ssh key used for login
    };
    # this will automatically load the zfs password prompt on login
    # and kill the other prompt so boot can continue
    postCommands = ''
      zpool import zroot
      echo "zfs load-key -a; killall zfs" >> /root/.profile
    '';
  };



  programs.mosh.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;







  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.julien = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/5+xJDYw1+qFnse+RfEnk1YbtEkpkVNzapWKPmpFIh julien@macintosh" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9Uzb7szWlux7HuxLZej9cBR5MhLz/vaAPPfSoozt2k julien@enigma.local" ];
  services.openssh.authorizedKeysFiles = [ "/home/julien/.ssh/authorized_keys" ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPortRanges = [{ from = 60000; to = 61000; }];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?


  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "tg3" "xhci_pci" "ahci" "ehci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "zroot/root";
      fsType = "zfs";
      options = [ "nofail" ];
    };

  fileSystems."/boot-1" =
    { device = "/dev/disk/by-uuid/15AF-22DB";
      fsType = "vfat";
      options = [ "nofail" ];
    };

  fileSystems."/boot-2" =
    { device = "/dev/disk/by-uuid/15EC-BC00";
      fsType = "vfat";
      options = [ "nofail" ];
    };

  swapDevices = [ ];
  

  luj = {
    filerun.enable = true;
    zfs-mails.enable = true;
      };






}
