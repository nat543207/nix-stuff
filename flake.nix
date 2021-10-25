{
  description = "An assortment of stuff I've written or packaged myself";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils/master;
  };

  outputs = { self, nixpkgs, flake-utils }:
  (flake-utils.lib.eachSystem ["x86_64-linux"] (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      # System-dependent flake attributes
      packages = {
        tagsistant = pkgs.callPackage ./pkgs/tagsistant {};
        nixos-rebuild = pkgs.callPackage ./pkgs/nixos-rebuild {};
      };
    }
  )) // {
    # System-independent flake attributes
    nixosModules = {
      user-config = import ./modules/user-config.nix;
    };
  };
}
