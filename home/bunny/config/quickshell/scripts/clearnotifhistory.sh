#!/usr/bin/env bash
# Drain mako's history by restoring and then dismissing without re-adding.
# Cap the loop so we never spin forever.
for _ in $(seq 1 200); do
  count=$(makoctl history -j 2>/dev/null | grep -c '"id"')
  [ "$count" -eq 0 ] && break
  makoctl restore >/dev/null 2>&1 || break
  makoctl dismiss --no-history >/dev/null 2>&1 || break
done
