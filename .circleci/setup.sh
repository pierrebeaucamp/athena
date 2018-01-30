#!/usr/bin/env bash

set -eo pipefail

apk add --update ca-certificates
nix-channel --remove nixpkgs
nix-channel --add https://nixos.org/channels/nixos-17.09 nixpkgs
nix-channel --update
