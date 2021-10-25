{ nixos-rebuild, nixUnstable, ... }:

nixos-rebuild.overrideAttrs (old: {
  nix = nixUnstable;
  # Manually patch nixos-rebuild.sh script since the substituteAll builder
  # isn't based on the generic builder and therefore doesn't run the standard
  # build phases - only preInstall and postInstall executed explicitly
  # https://github.com/NixOS/nixpkgs/blob/3b6c3bee9174dfe56fd0e586449457467abe7116/pkgs/build-support/substitute/substitute-all.sh
  postInstall = ''
    patch --no-backup-if-mismatch $target ${./flake-config-env-var.patch}
  '';
})
