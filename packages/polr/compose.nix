{pkgs, system ? builtins.currentSystem, noDev ? false, php ? pkgs.php74, phpPackages ? pkgs.php74Packages}:

let
  composerEnv = import ./composer-env.nix {
    inherit (pkgs) stdenv lib writeTextFile fetchurl unzip;
    inherit php phpPackages;
  };
in
import ./php-packages.nix {
  inherit composerEnv noDev;
  inherit (pkgs) fetchurl fetchgit fetchhg fetchsvn;
}
