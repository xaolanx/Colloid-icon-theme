{
  description = "My custom Colloid icon theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      schemes = [
        "default" "nord" "dracula" "gruvbox" "everforest"
        "catppuccin" "rosepine" "kanagawa" "all"
      ];

      colors = [
        "default" "purple" "pink" "red" "orange"
        "yellow" "green" "teal" "grey" "all"
      ];

      combinations =
        builtins.concatMap
          (scheme:
            builtins.map (color: {
              name = "${scheme}${color}";
              schemeVariant = scheme;
              colorVariant = color;
            })
            colors
          )
          schemes;

      customPackages = builtins.listToAttrs (builtins.map
        ({ name, schemeVariant, colorVariant }:
          {
            name = name;
            value = pkgs.callPackage ./colloid-icon-theme.nix {
              schemeVariants = [ schemeVariant ];
              colorVariants = [ colorVariant ];
            };
          })
        combinations);

    in {
      packages.${system} = customPackages // {
        default = customPackages.defaultdefault;
      };
    };
}
