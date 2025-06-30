{ lib
, stdenvNoCC
, gtk3
, hicolor-icon-theme
, jdupes
, schemeVariants ? [ ]
, colorVariants ? [ ]
}:

let
  allSchemes = [
    "default"
    "nord"
    "dracula"
    "gruvbox"
    "everforest"
    "catppuccin"
    "rosepine"
    "kanagawa"
    "all"
  ];

  allColors = [
    "default"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "teal"
    "grey"
    "all"
  ];

  # Validate input
  _ = lib.checkListOfEnum "custom-colloid-icon: scheme variants" allSchemes schemeVariants;
  __ = lib.checkListOfEnum "custom-colloid-icon: color variants" allColors colorVariants;

in

stdenvNoCC.mkDerivation rec {
  pname = "custom-colloid-icon";
  version = "2025-02-09";
  src = ./.;

  nativeBuildInputs = [ gtk3 jdupes ];
  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;
  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontCheckForBrokenSymlinks = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    name= ./install.sh \
      ${lib.optionalString (schemeVariants != [ ]) ("--scheme " + builtins.toString schemeVariants)} \
      ${lib.optionalString (colorVariants != [ ]) ("--theme " + builtins.toString colorVariants)} \
      --dest $out/share/icons

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

}
