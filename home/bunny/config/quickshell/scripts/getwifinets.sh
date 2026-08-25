#!/usr/bin/env bash
# Emits one line per visible WiFi network:
#   INUSE|SSID|SIGNAL|SECURITY|SAVED
# INUSE is 1 or 0. SAVED is 1 if a saved connection with that SSID exists.

saved_file=$(mktemp)
trap 'rm -f "$saved_file"' EXIT
nmcli -t -f NAME,TYPE connection show 2>/dev/null \
  | awk -F':' '$2=="802-11-wireless"{print $1}' > "$saved_file"

nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list 2>/dev/null \
| awk -F':' -v savedf="$saved_file" '
  BEGIN {
    while ((getline s < savedf) > 0) { seen[s]=1 }
    close(savedf)
  }
  {
    inuse = ($1 == "*") ? 1 : 0
    ssid  = $2
    sig   = $3
    sec   = $4
    if (ssid == "" ) next
    if (dupe[ssid]++) next
    saved = (ssid in seen) ? 1 : 0
    printf "%d|%s|%s|%s|%d\n", inuse, ssid, sig, sec, saved
  }
' | sort -t'|' -k3,3nr
