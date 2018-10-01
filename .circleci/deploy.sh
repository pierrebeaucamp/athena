#!/usr/bin/env sh

gem install neocities

mkdir -p $HOME/.config/neocities
echo $NEOCITIES >> $HOME/.config/neocities/config

neocities push result
