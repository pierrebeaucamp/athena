#!/usr/bin/env sh

mkdir -p $HOME/.config/neocities
echo -n $NEOCITIES_TOKEN >> $HOME/.config/neocities/config

neocities push -e nix-support result
