{ pkgs ? import <nixpkgs> {}}:

let
  python = import ./requirements.nix {
    inherit pkgs;
  };
in
  python.mkDerivation {
    name = "pierrebeaucamp.com";
    src = ./.;

    buildInputs = [
      pkgs.pandoc
      pkgs.haskellPackages.pandoc-citeproc
      pkgs.haskellPackages.pandoc-crossref
      pkgs.haskellPackages.pandoc-sidenote
    ];

    buildPhase = ''
      ${python.interpreter}/bin/python athena.py build
    '';

    installPhase = "";
    doCheck = false;
    propagateBuildInputs = builtins.attrValues python.packages;
  }
