{ pkgs ? import <nixpkgs> {}}:

let
  python = (import ./requirements.nix { inherit pkgs; });
  neocities = (import ./neocities-cli/default.nix {});
in
  python.mkDerivation {
    name = "pierrebeaucamp.com";
    src = ./.;

    buildInputs = [
      neocities
      pkgs.pandoc
      pkgs.haskellPackages.pandoc-citeproc
      pkgs.haskellPackages.pandoc-crossref
      pkgs.haskellPackages.pandoc-sidenote
    ] ++ builtins.attrValues python.packages;

    buildPhase = ''
      ${python.interpreter}/bin/python athena.py build
    '';

    installPhase = "";
    doCheck = false;
  }
