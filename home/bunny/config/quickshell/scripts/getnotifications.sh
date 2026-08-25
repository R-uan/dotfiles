#!/usr/bin/env bash
# Emits two JSON arrays separated by markers so the caller can parse both.
#   ACTIVE
#   [...]
#   HISTORY
#   [...]
echo "ACTIVE"
makoctl list -j 2>/dev/null || echo "[]"
echo "HISTORY"
makoctl history -j 2>/dev/null || echo "[]"
