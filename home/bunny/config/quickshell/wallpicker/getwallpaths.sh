#!/usr/bin/env bash
WALLPAPERS_PATH=$(readlink -f ~/.local/share/wallpapers)
find $WALLPAPERS_PATH -type f -iregex '.*\.\(png\|jpg\|jpeg\)$'
