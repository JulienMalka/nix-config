{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware.nix
      ./home-julien.nix
      ../../users/julien.nix
      ../../users/default.nix
      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  nixpkgs.config.allowUnsupportedSystem = false;
  networking.hostName = "macintosh"; # Define your hostname.

  networking.wireless.enable = false;

  hardware.asahi.addEdgeKernelConfig = true;
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.pkgs = lib.mkDefault pkgs;
  hardware.asahi.experimentalGPUInstallMode = "overlay";


  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;
  environment.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
  };

  services.xserver = {
    enable = true;
    layout = "fr";
    displayManager.gdm.enable = true;
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };

  services.tailscale.enable = true;
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;


  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  programs.dconf.enable = true;

  security.polkit.enable = true;

  services.tlp.enable = true;

  environment.systemPackages = with pkgs; [
    tailscale
    brightnessctl
  ];

  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  services.davfs2 = {
    enable = true;
  };

  security.pam.services.swaylock = { };

  programs.ssh.startAgent = true;

  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  services.autofs = {
    enable = true;
    debug = true;
    autoMaster =
      let
        mapConf = pkgs.writeText "auto" ''
          nuage -fstype=davfs,uid=1000,file_mode=600,dir_mode=700,conf=/home/julien/.davfs2/davfs2.conf,rw :https\://nuage.malka.family/remote.php/webdav/
        '';
      in
      ''
        /home/julien/clouds file:${mapConf}
      '';
  };

  system.stateVersion = "23.05"; # Did you read the comment?

}



