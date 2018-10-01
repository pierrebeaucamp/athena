#!/usr/bin/env sh

apk add --update ca-certificates
nix-channel --remove nixpkgs
nix-channel --add https://nixos.org/channels/nixos-18.03 nixpkgs
nix-channel --update
