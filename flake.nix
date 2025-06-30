{
  description = "My custom Colloid icon theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Customize your default variants here
        custom-colloid-icon = pkgs.callPackage ./colloid-icon-theme.nix {
          schemeVariants = [ "default" ];
          colorVariants = [ "default" ];
        };
      in {
        packages.default = custom-colloid-icon;
      }
    );
}
