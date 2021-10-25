{ autoreconfHook, fetchFromGitHub, stdenv, substituteAll,
  fuse, glib, libdbi, libdbiDrivers, libextractor, pkg-config }:

stdenv.mkDerivation rec {
  pname = "tagsistant";
  version = "0.8.2";

  src = fetchFromGitHub {
    "owner" = "StrumentiResistenti";
    "repo" = "tagsistant";
    "rev" = "0dabdca1077136b7626a2977410f910689c235b7";
    "sha256" = "tfiBGAzV8dGnTM27IqBJvpHaeF+4nC0sSOe7/EQ48Ro=";
};

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse glib libdbi libdbiDrivers libextractor ];

  patches = [
    # Patch libdbi initialization to point to Nix-managed drivers
    (substituteAll {
      src = ./libdbi_init_template.patch;
      inherit libdbiDrivers;
    })
  ];

  postPatch = ''
    echo "Removing out-of-store symlinks polluting repo..."
    find . -type l -delete
  '';
}

