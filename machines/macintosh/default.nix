# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  nixpkgs.config.allowUnsupportedSystem = false;
  networking.hostName = "macintosh"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = false;

  hardware.asahi.addEdgeKernelConfig = true;
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.pkgs = lib.mkDefault pkgs;

  hardware.video.hidpi.enable = true;

  services.tailscale.enable = true;
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  programs.dconf.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  services.tlp.enable = true;

  environment.systemPackages = with pkgs; [
    tailscale
    brightnessctl
  ];

  system.stateVersion = "23.05"; # Did you read the comment?

}


