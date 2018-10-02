#!/usr/bin/env sh

mkdir -p $HOME/.config/neocities
echo $NEOCITIES >> $HOME/.config/neocities/config

neocities push result
