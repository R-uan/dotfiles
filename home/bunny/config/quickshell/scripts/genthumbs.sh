#!/usr/bin/env bash
# Generates missing thumbnails. Arguments come in pairs: SOURCE OUTPUT
# (the caller names OUTPUT per the freedesktop thumbnail spec, so file
# managers share the cache). Prints each source it generated.
while [ $# -ge 2 ]; do
  src=$1 out=$2
  shift 2
  [ -s "$out" ] && continue
  mkdir -p "$(dirname "$out")"
  magick "$src[0]" -thumbnail 256x256 -strip "$out" 2>/dev/null && echo "$src"
done
