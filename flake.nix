{
  description = "A flake for my personnal configurations";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
    };

    homepage = {
      url = "github:JulienMalka/homepage";
      flake = false;
    };

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    unstable-plus-patches.url = "github:JulienMalka/nixpkgs/unstable-plus-patches";

    flake-utils.url = "github:numtide/flake-utils";

    colmena.url = "github:zhaofengli/colmena";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.11";
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-22_11.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    linkal = {
      url = "github:JulienMalka/Linkal/main";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "unstable";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/master";
    };

    nix-straight = {
      url = "github:codingkoi/nix-straight.el?ref=codingkoi/apply-librephoenixs-fix";
      flake = false;
    };
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs = {
        nix-straight.follows = "nix-straight";
      };
    };

    buildbot-nix.url = "github:JulienMalka/buildbot-nix";

    zotero-nix.url = "github:camillemndn/zotero-nix";
    nur.url = "github:nix-community/NUR";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib.extend (import ./lib inputs);
      machines_plats = lib.mapAttrsToList (name: value: value.arch) (lib.filterAttrs (n: v: builtins.hasAttr "arch" v) lib.luj.machines);
      mkMachine = import ./lib/mkmachine.nix inputs lib;

      nixpkgs_plats = builtins.listToAttrs (builtins.map
        (plat: {
          name = plat;
          value = import nixpkgs { system = plat; };
        })
        machines_plats);
    in
    rec {

      nixosModules = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./modules + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules)));

      nixosConfigurations = builtins.mapAttrs
        (name: value: (mkMachine {
          host = name;
          host-config = value;
          modules = self.nixosModules;
          nixpkgs = lib.luj.machines.${name}.nixpkgs_version;
          system = lib.luj.machines.${name}.arch;
          home-manager = lib.luj.machines.${name}.hm_version;
        }))
        (lib.importConfig ./machines);


      colmena =
        let
          deployableConfigurations = lib.filterAttrs (_: v: builtins.hasAttr "ipv4" lib.luj.machines.${v.config.networking.hostName}) nixosConfigurations;
        in
        {
          meta = {
            nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
            nodeNixpkgs = builtins.mapAttrs (_: v: v.pkgs) deployableConfigurations;
            nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs) deployableConfigurations;
            specialArgs.lib = lib;
          };
        } // builtins.mapAttrs
          (_: v: {
            imports = v._module.args.modules;
          })
          deployableConfigurations;


      packages = builtins.listToAttrs
        (builtins.map
          (plat: {
            name = plat;
            value =
              (lib.filterAttrs (name: value: (!lib.hasAttrByPath [ "meta" "platforms" ] value) || builtins.elem plat value.meta.platforms)
                (builtins.listToAttrs (builtins.map
                  (e: {
                    name = e;
                    value = nixpkgs_plats.${plat}.callPackage (./packages + "/${e}") { };
                  })
                  (builtins.attrNames (builtins.readDir ./packages)))));
          })
          machines_plats);

      machines = lib.luj.machines;

      checks = {
        packages = packages;
        machines = lib.mapAttrs (_: v: v.config.system.build.toplevel) self.nixosConfigurations;
      };
    };
}
