{
   description = "A flake for my personnal configurations";
   inputs = {
   nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
   nixos.url = "github:NixOS/nixpkgs/nixos-21.11";
   home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
	};

   neovim-nightly-overlay = {
            url = "github:nix-community/neovim-nightly-overlay";
        };

};

outputs = { self, nixos, home-manager, nixpkgs, neovim-nightly-overlay, nur, ... }@inputs :
{

  nixosModules = builtins.listToAttrs (map (x: {
        name = x;
        value = import (./modules + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./modules)));

   nixosConfigurations = {
	lisa = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
        modules =  builtins.attrValues self.nixosModules ++ [./configuration.nix ./config/hosts/lisa.nix		
        home-manager.nixosModules.home-manager {
		        home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.julien = import ./config/home/home-lisa.nix;
                nixpkgs.overlays = [
                  inputs.neovim-nightly-overlay.overlay
              ];
              
		}];

	};

   };
};



}
