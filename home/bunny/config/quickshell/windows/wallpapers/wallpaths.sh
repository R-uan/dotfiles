#!/usr/bin/env bash
# Lists wallpapers in $1 (newest first).
find "$1" -type f -iregex '.*\.\(png\|jpg\|jpeg\|webp\)$' -printf '%T@ %p\n' | sort -rn | cut -d' ' -f2-
