#!/usr/bin/env sh

mkdir -p $HOME/.config/neocities
echo $NEOCITIES_TOKEN >> $HOME/.config/neocities/config

neocities push result
