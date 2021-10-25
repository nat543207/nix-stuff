{ config, lib, options, ... }:

with lib;

let
  hmUsers = config.home-manager.users;

  hmExtension = { ... }: {
    options = {
      nixos = mkOption {
        # Use the submodule type declared as the value for `users.users` attributes
        type = options.users.users.type.functor.wrapped;
        default = {};
        defaultText = "{}";
        description = "Attributes propagated to `users.users` in NixOS";
      };
    };
  };
in {
  options = {
    # Hopefully home-manager description overrides the lack of one here
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith {
        # Have to use submoduleWith to match this with home-manager's declaration
        shorthandOnlyDefinesConfig = false;
        modules = toList (hmExtension);
      });
    };
  };

  config.users.extraUsers = mapAttrs (key: val: val.nixos) hmUsers;
}
